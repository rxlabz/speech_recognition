import Flutter
import UIKit
import Speech

public class SwiftSpeechRecognitionPlugin: NSObject, FlutterPlugin, SFSpeechRecognizerDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "speech_recognition", binaryMessenger: registrar.messenger())
    let instance = SwiftSpeechRecognitionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private let speechRecognizerFr = SFSpeechRecognizer(locale: Locale(identifier: "fr_FR"))!
  private let speechRecognizerEn = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))!
  private let speechRecognizerRu = SFSpeechRecognizer(locale: Locale(identifier: "ru_RU"))!
  private let speechRecognizerIt = SFSpeechRecognizer(locale: Locale(identifier: "it_IT"))!

  private var speechChannel: FlutterMethodChannel?

  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

  private var recognitionTask: SFSpeechRecognitionTask?

  private let audioEngine = AVAudioEngine()



  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    //result("iOS " + UIDevice.current.systemVersion)
    switch (call.method) {
    case "speech.activate":
      self.activateRecognition(result: result)
    case "speech.listen":
      self.startRecognition(lang: call.arguments as! String, result: result)
    case "speech.cancel":
      self.cancelRecognition(result: result)
    case "speech.stop":
      self.stopRecognition(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func activateRecognition(result: @escaping FlutterResult) {
    speechRecognizerFr.delegate = self
    speechRecognizerEn.delegate = self
    speechRecognizerRu.delegate = self
    speechRecognizerIt.delegate = self

    SFSpeechRecognizer.requestAuthorization { authStatus in
      OperationQueue.main.addOperation {
        switch authStatus {
        case .authorized:
          result(true)

        case .denied:
          result(false)

        case .restricted:
          result(false)

        case .notDetermined:
          result(false)
        }
      }
    }
  }

  private func startRecognition(lang: String, result: FlutterResult) {
    if audioEngine.isRunning {
      audioEngine.stop()
      recognitionRequest?.endAudio()
      result(false)
    } else {
      try! start(lang: lang)
      result(true)
    }
  }

  private func cancelRecognition(result: FlutterResult?) {
    if let recognitionTask = recognitionTask {
      recognitionTask.cancel()
      self.recognitionTask = nil
      if let r = result {
        r(false)
      }
    }
  }

  private func stopRecognition(result: FlutterResult) {
    if audioEngine.isRunning {
      audioEngine.stop()
      recognitionRequest?.endAudio()
    }
    result(false)
  }

  private func start(lang: String) throws {

    cancelRecognition(result: nil)

    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(AVAudioSessionCategoryRecord)
    try audioSession.setMode(AVAudioSessionModeMeasurement)
    try audioSession.setActive(true, with: .notifyOthersOnDeactivation)

    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

    guard let inputNode = audioEngine.inputNode else {
      fatalError("Audio engine has no input node")
    }
    guard let recognitionRequest = recognitionRequest else {
      fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object")
    }

    recognitionRequest.shouldReportPartialResults = true

    let speechRecognizer = getRecognizer(lang: lang)

    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
      var isFinal = false

      if let result = result {
        print("Speech : \(result.bestTranscription.formattedString)")
        self.speechChannel?.invokeMethod("onSpeech", arguments: result.bestTranscription.formattedString)
        isFinal = result.isFinal
        if isFinal {
          self.speechChannel!.invokeMethod(
             "onRecognitionComplete",
             arguments: result.bestTranscription.formattedString
          )
        }
      }

      if error != nil || isFinal {
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        self.recognitionRequest = nil
        self.recognitionTask = nil
      }
    }

    let RecognitionFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: RecognitionFormat) {
      (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      self.recognitionRequest?.append(buffer)
    }

    audioEngine.prepare()
    try audioEngine.start()

    speechChannel!.invokeMethod("onRecognitionStarted", arguments: nil)
  }

  private func getRecognizer(lang: String) -> Speech.SFSpeechRecognizer {
    switch (lang) {
    case "fr_FR":
      return speechRecognizerFr
    case "en_US":
      return speechRecognizerEn
    case "ru_RU":
      return speechRecognizerRu
    case "it_IT":
      return speechRecognizerIt
    default:
      return speechRecognizerFr
    }
  }

  public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
    if available {
      speechChannel?.invokeMethod("onSpeechAvailability", arguments: true)
    } else {
      speechChannel?.invokeMethod("onSpeechAvailability", arguments: false)
    }
  }
}
