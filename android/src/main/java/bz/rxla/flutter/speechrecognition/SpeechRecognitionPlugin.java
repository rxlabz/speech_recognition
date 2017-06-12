package bz.rxla.flutter.speechrecognition;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.ArrayList;
import java.util.Locale;

/**
 * SpeechRecognitionPlugin
 */
public class SpeechRecognitionPlugin implements MethodCallHandler, RecognitionListener {

    private static final String LOG_TAG = "SpeechRecognitionPlugin";

    private SpeechRecognizer speech;
    private MethodChannel speechChannel;
    String transcription = "";
    private boolean cancelled = false;
    private Intent recognizerIntent;
    private Activity activity;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "speech_recognition");
        channel.setMethodCallHandler(new SpeechRecognitionPlugin(registrar.activity(), channel));
    }

    private SpeechRecognitionPlugin(Activity activity, MethodChannel channel) {
        this.speechChannel = channel;
        this.speechChannel.setMethodCallHandler(this);
        this.activity = activity;

        speech = SpeechRecognizer.createSpeechRecognizer(activity.getApplicationContext());
        speech.setRecognitionListener(this);

        recognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true);
        recognizerIntent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        if (call.method.equals("speech.activate")) {
            // FIXME => Dummy activation verification : we assume that speech recognition permission
            // is declared in the manifest and accepted during installation ( AndroidSDK 21- )
            result.success(true);
            Locale locale = activity.getResources().getConfiguration().locale;
            Log.d(LOG_TAG, "Current Locale : " + locale.toString());
            speechChannel.invokeMethod("speech.onCurrentLocale", locale.toString());
        } else if (call.method.equals("speech.listen")) {
            recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, getLocale(call.arguments.toString()));
            cancelled = false;
            speech.startListening(recognizerIntent);
            result.success(true);
        } else if (call.method.equals("speech.cancel")) {
            speech.stopListening();
            cancelled = true;
            result.success(true);
        } else if (call.method.equals("speech.stop")) {
            speech.stopListening();
            cancelled = false;
            result.success(true);
        } else {
            result.notImplemented();
        }
    }

    private Locale getLocale(String code) {
        String[] localeParts = code.split("_");
        return new Locale(localeParts[0], localeParts[1]);
    }

    @Override
    public void onReadyForSpeech(Bundle params) {
        Log.d(LOG_TAG, "onReadyForSpeech");
        speechChannel.invokeMethod("speech.onSpeechAvailability", true);
    }

    @Override
    public void onBeginningOfSpeech() {
        Log.d("SYDOTY", "onRecognitionStarted");
        transcription = "";

        speechChannel.invokeMethod("speech.onRecognitionStarted", null);
    }

    @Override
    public void onRmsChanged(float rmsdB) {
        Log.d(LOG_TAG, "onRmsChanged : " + rmsdB);
    }

    @Override
    public void onBufferReceived(byte[] buffer) {
        Log.d(LOG_TAG, "onBufferReceived");
    }

    @Override
    public void onEndOfSpeech() {
        Log.d(LOG_TAG, "onEndOfSpeech");
        speechChannel.invokeMethod("speech.onRecognitionComplete", transcription);
    }

    @Override
    public void onError(int error) {
        Log.d(LOG_TAG, "onError : " + error);
        speechChannel.invokeMethod("speech.onSpeechAvailability", false);
        speechChannel.invokeMethod("speech.onError", error);
    }

    @Override
    public void onPartialResults(Bundle partialResults) {
        Log.d(LOG_TAG, "onPartialResults...");
        ArrayList<String> matches = partialResults
                .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
        transcription = matches.get(0);
        sendTranscription(false);

    }

    @Override
    public void onEvent(int eventType, Bundle params) {
        Log.d(LOG_TAG, "onEvent : " + eventType);
    }

    @Override
    public void onResults(Bundle results) {
        Log.d(LOG_TAG, "onResults...");
        ArrayList<String> matches = results
                .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
        String text = "";
        transcription = matches.get(0);
        Log.d(LOG_TAG, "onResults -> " + transcription);
        sendTranscription(true);
    }

    private void sendTranscription(boolean isFinal) {
        speechChannel.invokeMethod(isFinal ? "speech.onRecognitionComplete" : "speech.onSpeech", transcription);
    }

}
