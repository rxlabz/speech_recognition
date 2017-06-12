import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String recognized = '';

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  activateSpeechRecognizer() async {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.activate();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Expanded(child: new Text('Plugin example app')),
        ),
        body: new Center(
          child: new Column(children: [
            new Text(recognized),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: () => _speechRecognitionAvailable ? start() : null,
                  child: new Text('Listen'),
                ),
                new RaisedButton(
                  onPressed: () => _isListening ? cancel() : null,
                  child: new Text('Cancel'),
                ),
                new RaisedButton(
                  onPressed: () => _isListening ? stop() : null,
                  child: new Text('Stop'),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void start() => _speech
      .listen(locale: "en_US")
      .then((result) => print('_MyAppState.start => result ${result}'));

  void cancel() => _speech
      .cancel()
      .then((result) => print('_MyAppState.cancel => result ${result}'));

  void stop() => _speech
      .stop()
      .then((result) => print('_MyAppState.stop => result ${result}'));

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);
}
