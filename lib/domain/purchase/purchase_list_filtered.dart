import 'dart:async';

import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_list.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

/// Класс реализует список элементов Purchase для PurchaseOverview
/// Список закупок для отображения в катологе 
class PurchaseListFiltered {
  static const _log = Log('PurchaseListFiltered');
  final PurchaseList _purchaseList;
  final List<String> _statusList;
  ///
  ///
  PurchaseListFiltered({
    required PurchaseList purchaseList,
    required List<String> statusList,
  }): 
    _statusList = statusList,
    _purchaseList = purchaseList;
  ///
  ///
  Future<Result<List<Purchase>, Failure>> refresh(List<String> statusList) {
    final list = List<String>.from(statusList);
    if (list.isNotEmpty) {
      _statusList.clear();
      _statusList.addAll(list);
    }
    _log.debug('PurchaseListFiltered.refresh | _statusList: $_statusList');
    return _purchaseList.fetch()
      .then((result) {
        switch (result) {
          case Ok(value: final map):
            final List<Purchase> listFiltered = [];
            for (final entry in map.entries) {
              if (_statusList.contains(entry.value.status)) {
                listFiltered.add(entry.value);
              }
            }
            _log.debug('PurchaseListFiltered.refresh | listFiltered: $listFiltered');
            return Ok(listFiltered);
          case Err(: final error):
            _log.warning('PurchaseListFiltered.refresh | Error: $error');
            return Err(Failure(
              message: 'PurchaseListFiltered.refresh | Error: $error', stackTrace:
              StackTrace.current,
            ),);
        }
      });
  }
}
