#import <Cordova/CDV.h>
#import <Speech/Speech.h>

@interface SpeechRecognition : CDVPlugin

@property (nonatomic, strong) CDVInvokedUrlCommand * command;
@property (nonatomic, strong) CDVPluginResult* pluginResult;
@property (nonatomic, strong) SFSpeechRecognizer *sfSpeechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;

@property (assign) NSString *sessionCategory;
@property (assign) BOOL speechStartSent;
@property (assign) BOOL resetAudioEngine;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) start:(CDVInvokedUrlCommand*)command;
- (void) stop:(CDVInvokedUrlCommand*)command;
- (void) abort:(CDVInvokedUrlCommand*)command;

@end
