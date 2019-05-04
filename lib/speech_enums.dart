class SpeechRecognitionError {
  const SpeechRecognitionError._(this.value);
  factory SpeechRecognitionError.fromInt(int value) {
    try {
      return values[value];
    } catch(e) {
      return SpeechRecognitionError.unknown;
    }
  }

  final int value;

  /// Unknown error.
  static const SpeechRecognitionError unknown = SpeechRecognitionError._(0);

  /// Network operation timed out.
  static const SpeechRecognitionError networkTimeout = SpeechRecognitionError._(1);

  /// Other network related errors.
  static const SpeechRecognitionError network = SpeechRecognitionError._(2);

  /// Audio recording error.
  static const SpeechRecognitionError recording = SpeechRecognitionError._(3);

  /// Server sends error status.
  static const SpeechRecognitionError server = SpeechRecognitionError._(4);

  /// Other client side errors.
  static const SpeechRecognitionError client = SpeechRecognitionError._(5);

  /// No speech input.
  static const SpeechRecognitionError clientTimeout = SpeechRecognitionError._(6);

  /// No recognition result matched.
  static const SpeechRecognitionError noMatch = SpeechRecognitionError._(7);

  /// RecognitionService is busy.
  static const SpeechRecognitionError busy = SpeechRecognitionError._(8);

  /// Insufficient permissions.
  static const SpeechRecognitionError noPermission = SpeechRecognitionError._(9);

  static const List<SpeechRecognitionError> values = <SpeechRecognitionError>[
    networkTimeout,
    network,
    recording,
    server,
    client,
    clientTimeout,
    noMatch,
    busy,
    noPermission,
  ];

  static const List<String> _names = <String>[
    'unknown',
    'networkTimeout',
    'network',
    'recording',
    'server',
    'client',
    'clientTimeout',
    'noMatch',
    'busy',
    'noPermission',
  ];

  @override
  String toString() => 'SpeechRecognitionError.${_names[value]}';
}
