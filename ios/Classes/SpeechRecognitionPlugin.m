#import "SpeechRecognitionPlugin.h"
#import <speech_recognition/speech_recognition-Swift.h>

@implementation SpeechRecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSpeechRecognitionPlugin registerWithRegistrar:registrar];
}
@end
