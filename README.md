# speech_recognition


A flutter plugin to use the speech recognition iOS10+ / Android 

## Usage

```dart
//..
speech = new SpeechRecognizer()

// 1st launch : speech recognition permission / initialization
final isActivated = await speech.activate();
setState(() => authorized = res);
//..

// default locale : 'en_US'
speech.listen(locale:'fr_FR').then((result)=> print('result : $result'));

// ...

speech.cancel();

// ||

speech.stop();

```

The flutter app not only call methods on the host platform,
it also needs to receive method calls from host.

```dart

_speech.setAvailabilityHandler(onSpeechAvailability);
_speech.setRecognitionStartedHandler(onRecognitionStarted);
_speech.setRecognitionResultHandler(onRecognitionResult);
_speech.setRecognitionCompleteHandler(onRecognitionComplete);
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

### Android

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).