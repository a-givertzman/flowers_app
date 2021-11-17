class Response<T> {
  final int _errCount;
  final String _errDamp;
  final T _data;
  const Response({
    required int errCount,
    required String errDamp,
    required T data,
  }):
    _errCount = errCount,
    _errDamp = errDamp,
    _data = data;
  bool hasData() {
    return _data != null;
  }
  bool hasError() {
    return _errCount > 0;
  }
  String errorMessage() {
    return _errDamp;
  }
  T data() {
    return _data;
  }
}