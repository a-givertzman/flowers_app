import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_set_order.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef PurchaseProductId = String;
typedef PurchaseProductSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseProductSqlParams>;
///
/// Класс реализует данные продукта, 
/// будет являеться элементом списка в составе закупки
class PurchaseProduct {
  static const _log = Log('PurchaseProduct');
  late String client_id;
  late String purchase_id = '';
  late String purchase_content_id;
  late String product_id = '';
  late String product_name = '';
  late String product_detales = '';
  late String product_picture = '';
  late String product_description = '';
  late String status = '';
  late String sale_price = '';
  late String sale_currency = '';
  late String ordered_count = '';
  late String remains = '';
  final PurchaseProductSqlAccess? _remote;
  bool _valid = false;
  ///
  ///
  PurchaseProduct({
    required String userId,
    required String purchaseContentId,
    PurchaseProductSqlAccess? remote,
  }) : 
    client_id = userId, 
    purchase_content_id = purchaseContentId, 
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: "select * from purchase_content_preview where id = '${params.?}';");
      },
      entryBuilder: (row) {
        return row;
      },
    );
  ///
  /// Returns true if all field of the Order is Ok
  bool get valid => _valid;
  ///
  ///
  Result<PurchaseProduct, Failure> _fromRow(Map<String, dynamic> row) {
    final rowId = row['id'];
    if (rowId == null) {
      _valid = false;
      return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _valid = false;
        return Err(Failure(message: 'Purchase._fromRow | Error: Purchase invalid "id" in row: $row', stackTrace: StackTrace.current));
      }
      // id = '${row['id']}';
      client_id = '${row['client_id']}';
      purchase_id = '${row['purchase_id']}';
      purchase_content_id = '${row['purchase_content_id']}';
      product_id = '${row['product_id']}';
      product_name = '${row['product_name']}';
      product_detales = '${row['product_detales']}';
      product_picture = '${row['product_picture']}';
      product_description = '${row['product_description']}';
      status = '${row['status']}';
      sale_price = '${row['sale_price']}';
      sale_currency = '${row['sale_currency']}';
      ordered_count = '${row['ordered_count']}';
      remains = '${row['remains']}';
      // created = '${row['created']}';
      // updated = '${row['updated']}';
      // deleted = '${row['deleted']}';
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  /// Returns PurchaseProduct by it database ID
  Future<Result<PurchaseProduct, Failure>> fetch(String id) {
    final remote = _remote;
    if (remote != null) {
      return remote.fetch(params: id).then(
        (result) {
          switch (result) {
            case Ok(:final value):
              _log.debug('.fetch | result: $value');
              if (value.isNotEmpty) {
                final row = value.first;
                return _fromRow(row);
              } else {
                _valid = false;
                return Err(Failure(message: 'PurchaseProduct.fetch | Error: PurchaseProduct with id=$id is not found', stackTrace: StackTrace.current));
              }
            case Err(:final error):
              _log.warning('.fetch | Error: $error');
              _valid = false;
              return Err(Failure(message: 'PurchaseProduct.fetch | Error: $error', stackTrace: StackTrace.current));
          }
        },
        onError: (err) {
          _log.warning('.fetch | Error: $err');
          _valid = false;
          return Err(Failure(message: 'PurchaseProduct.fetch | Error: $err', stackTrace: StackTrace.current));
        },
      );
    } else {
      _valid = false;
      return Future.value(Err(Failure(message: 'PurchaseProduct.fetch | Error: _remote is not initilized', stackTrace: StackTrace.current)));
    }
  }
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> removeOrder() {
    return setOrder(count: 0);
  }
  ///
  ///
  Future<Result<Map<String, dynamic>, Failure>> setOrder({required int count}) {
    return PurchaseSetOrder(
      id: '0',
      userId: client_id,
    //   DataSet<Map<String, dynamic>>(
    //     params: ApiParams({
    //       'tableName': 'order',
    //     }),
    //     apiRequest: ApiRequest(
    //       url: (count <= 0)
    //         ? 'https://u1489690.isp.regruhosting.ru/remove-order'
    //         : 'https://u1489690.isp.regruhosting.ru/add-order',
    //     ),
    //   ),
    ).send(count, purchase_content_id, product_id, purchase_id);
  }
  ///
  ///
  Future<Result<PurchaseProduct, Failure>> refresh() {
  // Future<DataObject> refresh() {
    return _remote.fetch(
      params: {
        'client/id': _userId,
        'purchase/id': '${this['purchase/id']}',
        'purchase_content/id': _purchaseContentId,
      },
    );
  }
}
///
///
class PurchaseProductSqlParams {
  final String? clientId;
  final String? purchaseId;
  final String? purchaseContentId;
  PurchaseProductSqlParams({
    this.clientId,
    this.purchaseId,
    this.purchaseContentId,
  });
}
