# speech_recognition

A flutter plugin to use the speech recognition iOS10+ / Android 4.1+

- [Basic Example](https://github.com/rxlabz/speech_recognition/tree/master/example)
- [Sytody, speech to todo app](https://github.com/rxlabz/sytody)

![screenshot](speech_reco_shots.png)

## [Installation](https://pub.dartlang.org/packages/speech_recognition#pub-pkg-tab-installing)

1. Depend on it
Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  speech_recognition: "^0.3.0"
```

2. Install it
You can install packages from the command line:

```
$ flutter packages get
```

3. Import it
Now in your Dart code, you can use:

```dart
import 'package:speech_recognition/speech_recognition.dart';
```

## Usage

```dart
//..
_speech = SpeechRecognition();

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
// the iOS API sends intermediate results,
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

### Recognition

- iOS : [Speech API](https://developer.apple.com/reference/speech)
- Android : [SpeechRecognizer](https://developer.android.com/reference/android/speech/SpeechRecognizer.html)

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

#### :warning: iOS : Swift project

### Android

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

## Limitation

On iOS, by default the plugin is configured for French, English, Russian, Spanish, Italian.
On Android, without additional installations, it will probably works only with the default device locale. 

## Troubleshooting

If you get a MissingPluginException, try to `flutter build apk` on Android, or `flutter build ios`

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).