import 'dart:async';

import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

class PurchaseList {
  final _streamController = StreamController<List<dynamic>>();
  late DataSource _dataSource;
  late DataSet _dataSet;
  Stream<List<dynamic>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }

  PurchaseList({
    required dataSource,
    required dataSetName,
  }) {
    print('[PurchaseList.constructor]');
    _dataSource = dataSource;
    _dataSet = dataSource.dataSet(dataSetName);
  }

  Future refresh() async {
    _dispatch();
  }

  void _dispatch() async {
    print('[PurchaseList._dispatch]');
    _streamController.sink.add(List.empty());
    _dataSet.fetch()
      .then(
        (sqlMap) {
          List<dynamic> purchaseList = [];
            for (var i = 0; i < sqlMap.length; i++) {
            final row = sqlMap[i];
            purchaseList.add(
              Purchase(id: row['id']).fromRow(row)
            );
          }
          _streamController.sink.add(purchaseList);
        }
      )
      .catchError((e) {
        print('[PurchaseList.handleError]');
        print(e);
        _streamController.addError(e);
      });
  }
}