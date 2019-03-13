//
//  Created by jcesarmobile on 30/11/14.
//  Updates and enhancements by Wayne Fisher (Fisherlea Systems) 2018-2019.
//

#import "SpeechRecognition.h"
#import <Speech/Speech.h>

#if 0
#define DBG(a)          NSLog(a)
#define DBG1(a, b)      NSLog(a, b)
#define DBG2(a, b, c)   NSLog(a, b, c)
#else
#define DBG(a)
#define DBG1(a, b)
#define DBG2(a, b, c)
#endif

@implementation SpeechRecognition

- (void) pluginInitialize {
    NSError *error;

    // We need to be notified of route changes to know when a
    // Bluetooth headset becomes active. The audioEngine needs to be
    // re-initialized in this case.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:nil];

    DBG(@"[sr] pluginInitialize()");

    NSString * output = [self.commandDelegate.settings objectForKey:[@"speechRecognitionAllowAudioOutput" lowercaseString]];
    if(output && [output caseInsensitiveCompare:@"true"] == NSOrderedSame) {
        // If the allow audio output preference is set, the need to change the session category.
        // This allows for speech recognition and speech synthesis to be used in the same app.
        self.sessionCategory = AVAudioSessionCategoryPlayAndRecord;
    } else {
        // Maintain the original functionality for backwards compatibility.
        self.sessionCategory = AVAudioSessionCategoryRecord;
    }

    self.resetAudioEngine = NO;
    self.audioEngine = [[AVAudioEngine alloc] init];
    self.audioSession = [AVAudioSession sharedInstance];

    if(![self.audioSession setCategory:self.sessionCategory
                                  mode:AVAudioSessionModeMeasurement
                               options:(AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionAllowBluetoothA2DP)
                                 error:&error]) {
        NSLog(@"[sr] Unable to setCategory: %@", error);
    }
}

- (void)routeChanged:(NSNotification *)notification {
    BOOL resetAudioEngine = NO;

    NSNumber *reason = [notification.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey];

    DBG(@"[sr] routeChanged()");

    AVAudioSessionRouteDescription *route;
    AVAudioSessionPortDescription *port;

    if ([reason unsignedIntegerValue] == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        NSLog(@"[sr] AVAudioSessionRouteChangeReasonNewDeviceAvailable");
        resetAudioEngine = YES;

        route = self.audioSession.currentRoute;
        port = route.inputs[0];
        NSLog(@"[sr] New device is %@", port.portType);
    } else if ([reason unsignedIntegerValue] == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        NSLog(@"[sr] AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
        resetAudioEngine = YES;

        route = [notification.userInfo objectForKey:AVAudioSessionRouteChangePreviousRouteKey];
        port = route.inputs[0];
        NSLog(@"[sr] Removed device %@", port.portType);

        route = self.audioSession.currentRoute;
        port = route.inputs[0];
        NSLog(@"[sr] Now using device %@", port.portType);
    } else if ([reason unsignedIntegerValue] == AVAudioSessionRouteChangeReasonCategoryChange) {
        NSLog(@"[sr] AVAudioSessionRouteChangeReasonCategoryChange");
        
        AVAudioSessionCategory category = [self.audioSession category];
        
        NSLog(@"[sr] AVAudioSession category: %@", category);
        
        if(![category isEqualToString:AVAudioSessionCategoryRecord] &&
           ![category isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
            if([category isEqualToString:AVAudioSessionCategoryPlayback]) {
                category = AVAudioSessionCategoryPlayAndRecord;
            } else {
                category = self.sessionCategory;
            }
            
            [self.audioSession setCategory:category error:nil];
        }
    }

    if(resetAudioEngine) {
        // If a Bluetooth device has been added or removed, we need to
        // re-initialize the audioEngine to adapt to the different
        // sampling rate of the Bluetooth headset (8kHz) vs the mic (44.1kHz).

        NSLog(@"[sr] Need to reset audioEngine");
        self.resetAudioEngine = YES;

        // If we are currently running, we need to stop and release the
        // existing recognition tasks. Otherwise, nothing gets received.
        [self stopAndRelease];
    }
}

- (void) init:(CDVInvokedUrlCommand*)command
{
    // This may be called multiple times by different instances of the Javascript SpeechRecognition object.
    NSLog(@"[sr] init()");

    self.pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:self.pluginResult callbackId:command.callbackId];
}

- (void) start:(CDVInvokedUrlCommand*)command
{
    DBG(@"[sr] start()");
    if (!NSClassFromString(@"SFSpeechRecognizer")) {
        [self sendErrorWithMessage:@"No speech recognizer service available." andCode:4];
        return;
    }

    self.command = command;
    [self sendEvent:(NSString *)@"start"];
    
    if(self.resetAudioEngine) {
        NSLog(@"[sr] Reseting audioEngine");
        self.audioEngine = [self.audioEngine init];
        self.resetAudioEngine = NO;
    }

    [self recognize];
}

- (void) recognize
{
    DBG(@"[sr] recognize()");
    NSString * lang = [self.command argumentAtIndex:0];
    if (lang && [lang isEqualToString:@"en"]) {
        lang = @"en-US";
    }

    if (![self permissionIsSet]) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                    [self recordAndRecognizeWithLang:lang];
                } else {
                    [self sendErrorWithMessage:@"Permission not allowed" andCode:4];
                }
            });
        }];
    } else {
        [self recordAndRecognizeWithLang:lang];
    }
}

- (void) recordAndRecognizeWithLang:(NSString *) lang
{
    DBG1(@"[sr] recordAndRecognizeWithLang(%@)", lang);
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:lang];
    self.sfSpeechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    if (!self.sfSpeechRecognizer) {
        [self sendErrorWithMessage:@"The language is not supported" andCode:7];
    } else {

        // Cancel the previous task if it's running.
        if ( self.recognitionTask ) {
            [self.recognitionTask cancel];
            self.recognitionTask = nil;
        }

        [self initAudioSession];

        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        self.recognitionRequest.shouldReportPartialResults = [[self.command argumentAtIndex:1] boolValue];

        self.speechStartSent = FALSE;

        self.recognitionTask = [self.sfSpeechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult *result, NSError *error) {

            if (error) {
                NSLog(@"[sr] resultHandler error (%d) %@", (int) error.code, error.description);
                [self stopAndRelease];
                [self sendErrorWithMessage:error.localizedDescription andCode:3];
            }

            if(!self.speechStartSent) {
                [self sendEvent:(NSString *)@"speechstart"];
                self.speechStartSent = TRUE;
            }

            if (result) {
                NSMutableArray * alternatives = [[NSMutableArray alloc] init];
                int maxAlternatives = [[self.command argumentAtIndex:2] intValue];
                for ( SFTranscription *transcription in result.transcriptions ) {
                    if (alternatives.count < maxAlternatives) {
                        float confMed = 0;
                        for ( SFTranscriptionSegment *transcriptionSegment in transcription.segments ) {
                            //NSLog(@"[sr] transcriptionSegment.confidence %f", transcriptionSegment.confidence);
                            confMed +=transcriptionSegment.confidence;
                        }
                        NSMutableDictionary * resultDict = [[NSMutableDictionary alloc]init];
                        [resultDict setValue:transcription.formattedString forKey:@"transcript"];
                        [resultDict setValue:[NSNumber numberWithBool:result.isFinal] forKey:@"final"];
                        [resultDict setValue:[NSNumber numberWithFloat:confMed/transcription.segments.count]forKey:@"confidence"];
                        [alternatives addObject:resultDict];
                    }
                }
                [self sendResults:@[alternatives]];
                if ( result.isFinal ) {
                    if(self.speechStartSent) {
                        [self sendEvent:(NSString *)@"speechend"];
                        self.speechStartSent = FALSE;
                    }

                    [self stopAndRelease];
                }
            }
        }];

        AVAudioFormat *recordingFormat = [self.audioEngine.inputNode outputFormatForBus:0];
        DBG1(@"[sr] recordingFormat: sampleRate:%lf", recordingFormat.sampleRate);
        [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [self.recognitionRequest appendAudioPCMBuffer:buffer];
        }];

        [self.audioEngine prepare];
        [self.audioEngine startAndReturnError:nil];

        [self sendEvent:(NSString *)@"audiostart"];
    }
}

- (void) initAudioSession
{
    NSError *error;

    if(![self.audioSession setActive:YES
                         withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"[sr] Unable to setActive:YES: %@", error);
    }
}

- (BOOL) permissionIsSet
{
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    return status != SFSpeechRecognizerAuthorizationStatusNotDetermined;
}

-(void) sendResults:(NSArray *) results
{
    NSMutableDictionary * event = [[NSMutableDictionary alloc]init];
    DBG(@"[sr] sendResults()");
    [event setValue:@"result" forKey:@"type"];
    [event setValue:nil forKey:@"emma"];
    [event setValue:nil forKey:@"interpretation"];
    [event setValue:[NSNumber numberWithInt:0] forKey:@"resultIndex"];
    [event setValue:results forKey:@"results"];

    self.pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:event];
    [self.pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:self.pluginResult callbackId:self.command.callbackId];
    DBG(@"[sr] sendResults() complete");
}

-(void) sendErrorWithMessage:(NSString *)errorMessage andCode:(NSInteger) code
{
    NSMutableDictionary * event = [[NSMutableDictionary alloc]init];
    DBG2(@"[sr] sendErrorWithMessage: (%d) %@", (int) code, errorMessage);
    [event setValue:@"error" forKey:@"type"];
    [event setValue:[NSNumber numberWithInteger:code] forKey:@"error"];
    [event setValue:errorMessage forKey:@"message"];
    self.pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:event];
    [self.pluginResult setKeepCallbackAsBool:NO];
    [self.commandDelegate sendPluginResult:self.pluginResult callbackId:self.command.callbackId];
    DBG(@"[sr] sendErrorWithMessage() complete");
}

-(void) sendEvent:(NSString *) eventType
{
    NSMutableDictionary * event = [[NSMutableDictionary alloc]init];
    DBG1(@"[sr] sendEvent: %@", eventType);
    [event setValue:eventType forKey:@"type"];
    self.pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:event];
    [self.pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:self.pluginResult callbackId:self.command.callbackId];
    DBG(@"[sr] sendEvent() complete");
}

-(void) stop:(CDVInvokedUrlCommand*)command
{
    DBG(@"[sr] stop()");
    [self stopOrAbort];
}

-(void) abort:(CDVInvokedUrlCommand*)command
{
    DBG(@"[sr] abort()");
    [self stopOrAbort];
}

-(void) stopOrAbort
{
    DBG(@"[sr] stopOrAbort()");
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self sendEvent:(NSString *)@"audioend"];

        if(self.recognitionRequest) {
            [self.recognitionRequest endAudio];
        }
    }
}

-(void) stopAndRelease
{
    DBG(@"[sr] stopAndRelease()");
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        [self sendEvent:(NSString *)@"audioend"];
    }
    [self.audioEngine.inputNode removeTapOnBus:0];

    if(self.recognitionRequest) {
        [self.recognitionRequest endAudio];
        self.recognitionRequest = nil;
    }

    if(self.recognitionTask) {
        if(self.recognitionTask.state != SFSpeechRecognitionTaskStateCompleted) {
            [self.recognitionTask cancel];
        }
        self.recognitionTask = nil;
    }

    /* TODO: Disabled for now.
     * Maybe should be performed by HeadsetControl.disconnect???
     * Or maybe allow use of a plugin parameter/option to disable this???
    if(self.audioSession) {
        NSError *error;

        NSLog(@"setActive:NO");
        if(![self.audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
            NSLog(@"[sr] Unable to setActive:NO: %@", error);
        }
    }
    */

    [self sendEvent:(NSString *)@"end"];
}

@end
