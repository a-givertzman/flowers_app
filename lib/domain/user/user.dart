import 'dart:async';

import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

class User {
  final _streamController = StreamController<List<dynamic>>();
  late DataSource _dataSource;
  late DataSet _dataSet;
  Stream<List<dynamic>> get authStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }
  bool isRequesting = false;
  final String id;
  final String name;
  final double account;
  User({
    required this.id, 
    required this.name, 
    required this.account
  });
  void _dispatch() async {
    print('[PurchaseList._dispatch]');
    //TODO Implement _dispatch method of User class
  }
}