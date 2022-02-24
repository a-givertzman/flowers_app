import 'dart:async';

import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';

/// Класс реализует список элементов Purchase для PurchaseOverview
/// Список закупок для отображения в катологе 
class PurchaseListFiltered {
  static const _debug = true;
  final PurchaseList _purchaseList;
  final List<String> _statusList;
  final _streamController = StreamController<List<Purchase>>();
  PurchaseListFiltered({
    required PurchaseList purchaseList,
  }): 
    _statusList = ['active'],
    _purchaseList = purchaseList;
  Future<List<Purchase>> refresh(List<String> statusList) {
    log(_debug, '[PurchaseListFiltered.refresh] statusList: ', statusList);
    if (statusList.isNotEmpty) {
      _statusList.clear();
      _statusList.addAll(statusList);
    }
    log(_debug, '[PurchaseListFiltered.refresh] _statusList: ', _statusList);
    return _purchaseList.fetch()
      .then((list) {
        // log(_debug, '[PurchaseListFiltered.refresh] list: ', list);
        final listFiltered = list.where(
          (purchase) => _statusList.contains('${purchase['status']}'),
        ).toList();
        log(_debug, '[PurchaseListFiltered.refresh] listFiltered: ', listFiltered);
        _streamController.sink.add(listFiltered);
        return listFiltered;
      });
  }
  Future<void> _dispatch() {
    return refresh(_statusList.toList());
  }
  Stream<List<Purchase>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }
}
