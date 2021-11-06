import 'package:flowers_app/domain/core/entities/convert.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует данные продукта, 
/// будет являеться элементом списка в составе закупки
class PurchaseProduct extends DataObject{
  // late String purchaseId;
  late String id;
  // @override
  // final DataSet remote;
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

  // PurchaseProduct({
  //   required this.id,
  //   // required this.remote,
  // });

  // @override
  // Future<dynamic> fetch({params}) async {
  //   if (remote != null) {
  //     return await remote!
  //       .fetch()
  //       .then(
  //         (sqlMap) {
  //           for (var i = 0; i < sqlMap.length; i++) {
  //             this['$i'] = sqlMap[i];
  //           }
  //           return this;
  //         }
  //       ).catchError((e) {
  //         final classInst = this.runtimeType.toString();
  //         throw Exception((message) =>
  //           'Ошибка в методе fetch класса $classInst:\n$message\n$e'
  //         );
  //       });  
  //   } else {
  //     final classInst = this.runtimeType.toString();
  //     throw Exception((message) =>
  //       'Ошибка, remote is NULL в методе fetch класса $classInst:\n$message'
  //     );
  //   }
  // }
}
