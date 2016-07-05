#import <Cordova/CDV.h>
#import "ISpeechSDK.h"

@interface SpeechRecognition : CDVPlugin <ISSpeechRecognitionDelegate>

@property (nonatomic,strong) CDVInvokedUrlCommand * command;
@property (nonatomic,strong) CDVPluginResult* pluginResult;
@property (nonatomic,strong) ISSpeechRecognition* recognition;

- (void) init:(CDVInvokedUrlCommand*)command;
- (void) start:(CDVInvokedUrlCommand*)command;
- (void) stop:(CDVInvokedUrlCommand*)command;
- (void) abort:(CDVInvokedUrlCommand*)command;

@end
