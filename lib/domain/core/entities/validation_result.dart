class ValidationResult {
  final bool _valid;
  final String _message;
  ValidationResult({
    required valid,
    required message,
  }) :_valid = valid, _message = message;
  bool valid() {
    return _valid;
  }
  String message() {
    return _message;
  }
} 