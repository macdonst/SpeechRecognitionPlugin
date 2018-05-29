#import <Cordova/CDV.h>
#import "iSpeechSDK.h"
#import <Speech/Speech.h>

@interface SpeechRecognition : CDVPlugin <ISSpeechRecognitionDelegate>

@property (nonatomic, strong) CDVInvokedUrlCommand * command;
@property (nonatomic, strong) CDVPluginResult* pluginResult;
@property (nonatomic, strong) ISSpeechRecognition* iSpeechRecognition;
@property (nonatomic, strong) SFSpeechRecognizer *sfSpeechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;

@property (assign) BOOL speechStartSent;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) start:(CDVInvokedUrlCommand*)command;
- (void) stop:(CDVInvokedUrlCommand*)command;
- (void) abort:(CDVInvokedUrlCommand*)command;

@end
