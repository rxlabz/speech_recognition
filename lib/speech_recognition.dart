import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';

typedef void AvailabilityHandler(bool result);
typedef void StringResultHandler(String text);

/// the channel to control the speech recognition
class SpeechRecognition {
  static const MethodChannel _channel =
      const MethodChannel('speech_recognition');

  static final SpeechRecognition _speech = new SpeechRecognition._internal();

  factory SpeechRecognition() => _speech;

  SpeechRecognition._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  AvailabilityHandler availabilityHandler;

  StringResultHandler currentLocaleHandler;
  StringResultHandler recognitionResultHandler;

  VoidCallback recognitionStartedHandler;

  StringResultHandler recognitionCompleteHandler;
  
  VoidCallback errorHandler;

  /// ask for speech  recognizer permission
  Future activate() => _channel.invokeMethod("speech.activate");

  /// start listening
  Future listen({String locale}) =>
      _channel.invokeMethod("speech.listen", locale);

  /// cancel speech
  Future cancel() => _channel.invokeMethod("speech.cancel");
  
  /// stop listening
  Future stop() => _channel.invokeMethod("speech.stop");

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "speech.onSpeechAvailability":
        availabilityHandler(call.arguments);
        break;
      case "speech.onCurrentLocale":
        currentLocaleHandler(call.arguments);
        break;
      case "speech.onSpeech":
        recognitionResultHandler(call.arguments);
        break;
      case "speech.onRecognitionStarted":
        recognitionStartedHandler();
        break;
      case "speech.onRecognitionComplete":
        recognitionCompleteHandler(call.arguments);
        break;
      case "speech.onError":
        errorHandler();
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}
