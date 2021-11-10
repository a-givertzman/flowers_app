import 'package:flowers_app/infrastructure/api/responce.dart';

class ToList {
  final Response _response;
  const ToList({
    required Response response,
  }):
    _response = response;
  List toList() {
    // print('[ToList.toList] data:');
    // print(data);
    final data = _response.data();
    final List list = [];
    for (var key in data.keys) {
      list.add(data[key]);
    }
    return list;
  }
}