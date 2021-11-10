class Response {
  final int _errCount;
  final String _errDamp;
  final Map _data;
  const Response({
    required int errCount,
    required String errDamp,
    required Map data,
  }):
    _errCount = errCount,
    _errDamp = errDamp,
    _data = data;
  bool hasData() {
    return _data.isNotEmpty;
  }
  bool hasError() {
    return _errCount > 0;
  }
  String errorMessage() {
    return _errDamp;
  }
  Map data() {
    return _data;
  }
}