import 'dart:async';

import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список продуктов в закупке
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class PurchaseContent extends DataObject{
  // late String purchaseId;
  late String id;
  @override
  final _streamController = StreamController<List<dynamic>>();
  final DataSet remote;
  ApiParams? _params;

  Stream<List<dynamic>> get dataStream {
    _streamController.onListen = _dispatch;
    return  _streamController.stream;
  }

  // String? purchaseName;
  // double? salePrice;
  // String? saleCurrency;
  // double? shipping;
  // int? count;
  // int? remains;
  // String? productId;
  // String? productGroup;
  // String? productName;
  // String? productDetales;
  // String? productPrimaryPrice;
  // String? productPrimaryCurrency;
  // String? productPrimaryOrderQuantity;
  // String? productOrderQuantity;
  // DateTime? created;
  // DateTime? updated;
  // DateTime? deleted;

  PurchaseContent({
    required this.id,
    required this.remote,
  });

  Future refresh() async {
    _dispatch();
  }

  void _dispatch() async {
    print('[PurchaseContent._dispatch]');
    _streamController.sink.add(List.empty());
    fetch(params: _params)
      .then(
        (data) {
          _streamController.sink.add(data);
        }
      )
      .catchError((e) {
        print('[PurchaseContent._dispatch handleError]');
        print(e);
        _streamController.addError(e);
      });
  }

  @override
  Future<dynamic> fetch({params}) async {
    _params = params;
    print('params:');
    print(params);
    if (remote != null) {
      return await remote
        .fetch(params: params)
        .then(
          (sqlMap) {
            List<dynamic> list = [];
            for (var i = 0; i < sqlMap.length; i++) {
              final r = sqlMap[i];
              final p = PurchaseProduct().fromRow(r);
              this['$i'] = p;
              list.add(p);
            }
            return list;
          }
        ).catchError((e) {
          final classInst = this.runtimeType.toString();
          throw Exception((message) =>
            'Ошибка в методе fetch класса $classInst:\n$message\n$e'
          );
        });  
    } else {
      final classInst = this.runtimeType.toString();
      throw Exception((message) =>
        'Ошибка, remote is NULL в методе fetch класса $classInst:\n$message'
      );
    }
  }}
