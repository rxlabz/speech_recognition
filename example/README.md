# speech_recognition_example

Demonstrates how to use the speech_recognition plugin.

![screenshot](https://github.com/rxlabz/speech_recognition/blob/master/screenshot.png)

## Usage

```dart
//..
_speech = new SpeechRecognition();

// The flutter app not only call methods on the host platform,
// it also needs to receive method calls from host.
_speech.setAvailabilityHandler((bool result) 
  => setState(() => _speechRecognitionAvailable = result));

// handle device current locale detection
_speech.setCurrentLocaleHandler((String locale) =>
 setState(() => _currentLocale = locale));

_speech.setRecognitionStartedHandler(() 
  => setState(() => _isListening = true));

// this handler will be called during recognition. 
// iOs allow to send the intermediate results,
// On my Android device, only the final transcription is received
_speech.setRecognitionResultHandler((String text) 
  => setState(() => transcription = text));

_speech.setRecognitionCompleteHandler(() 
  => setState(() => _isListening = false));

// 1st launch : speech recognition permission / initialization
_speech
    .activate()
    .then((res) => setState(() => _speechRecognitionAvailable = res));
//..

speech.listen(locale:_currentLocale).then((result)=> print('result : $result'));

// ...

speech.cancel();

// ||

speech.stop();

```


## Permissions

### iOS

infos.plist, add :
- Privacy - Microphone Usage Description
- Privacy - Speech Recognition Usage Description

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This application needs to access your microphone</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This application needs the speech recognition permission</string>
```
#### :warning: Swift project

This plugin is written in swift, so to use with in a Flutter/ObjC project, 
you need to convert the project to "Current swift syntax" ( Edit/Convert/current swift syntax)  


### Android

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```


## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).
