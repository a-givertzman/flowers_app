import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
typedef PurchaseProductSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseProductSqlParams>;
///
/// Product of the PurchaseContent, 
class PurchaseProduct {
  static const _log = Log('PurchaseProduct');
  /// purchase_content -> id
  late String id = '';
  late String purchase_id = '';
  late String product_id = '';
  late String purchase = '';
  late String product_name = '';
  late String product_detales = '';
  late String product_picture = '';
  late String product_description = '';
  late String sale_price = '';
  late String sale_currency = '';
  /// Доставка за единицу
  late String shipping = '';
  /// количество единиц товара в заказе
  late String amount = '';
  /// количество количество единиц товара в закупке (остаток)
  late String remains = '';
  late PurchaseStatus status = PurchaseStatus.notCampled();
  late String created = '';
  late String updated = '';
  late String deleted = '';
  final PurchaseProductSqlAccess? _remote;
  bool _valid = false;
  ///
  ///
  PurchaseProduct({
    required String purchaseContentId,
    PurchaseProductSqlAccess? remote,
  }) : 
    id = purchaseContentId, 
    _remote = remote ?? _sqlAccess(purchaseContentId);
  ///
  ///
  static PurchaseProductSqlAccess _sqlAccess(String purchaseContentId) {
    return SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        if (params?.customerId != null) {
          return Sql(sql: """
            SELECT cord.id,
              cord.customer_id,
              cord.purchase_content_id,
              cord.count,
              cord.paid,
              cord.distributed,
              cord.to_refound,
              cord.refounded,
              cord.description,
              cord.created,
              cord.updated,
              cord.deleted,
              cu.name AS customer,
              p.name AS product,
              pu.name AS purchase
            FROM customer_order cord
              JOIN customer cu ON cord.customer_id = cu.id
              JOIN purchase_content puc ON cord.purchase_content_id = puc.id
              JOIN purchase pu ON puc.purchase_id = pu.id
              JOIN product p ON puc.product_id = p.id;')
            where customer_id = ${params?.customerId} 
            and cord.id = $purchaseContentId;
          """);
        } else {
          return Sql(sql: 'select * from purchase_content_view where id = $purchaseContentId;');
        }
      },
      entryBuilder: (row) {
        return row;
      },
    );
  }
  ///
  /// Returns true if all field of the Order is Ok
  bool get valid => _valid;
  ///
  /// Returns Order parsed from database row Map<String, dynamic>
  PurchaseProduct.fromRow(Map<String, dynamic> row): _remote = _sqlAccess('${row['id']}') {
    _fromRow(row);
  }
  ///
  ///
  Result<PurchaseProduct, Failure> _fromRow(Map<String, dynamic> row) {
    final rowId = row['id'];
    if (rowId == null) {
      _valid = false;
      return Err(Failure(message: 'PurchaseProduct._fromRow | Error: PurchaseProduct invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      if ('$rowId'.isEmpty) {
        _valid = false;
        return Err(Failure(message: 'PurchaseProduct._fromRow | Error: PurchaseProduct invalid "id" in row: $row', stackTrace: StackTrace.current));
      }
      id = '${row['id']}';
      purchase_id = '${row['purchase_id']}';
      product_id = '${row['product_id']}';
      sale_price = '${row['sale_price']}';
      sale_currency = '${row['sale_currency']}';
      shipping = '${row['shipping']}';                // доставка за единицу
      purchase = '${row['purchase']}';
      product_name = '${row['product']}';
      product_detales = '${row['product_detales']}';
      product_description = '${row['product_description']}';
      product_picture = '${row['product_picture']}';
      amount = '${row['count']}';
      remains = '${row['remains']}';
      status = PurchaseStatus(status: '${row['status']}');
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _valid = true;
      return Ok(this);
    }    
  }
  ///
  /// Returns PurchaseProduct by it database ID
  Future<Result<PurchaseProduct, Failure>> fetch({PurchaseProductSqlParams? params}) {
    final remote = _remote;
    if (remote != null) {
      return remote.fetch(params: params).then(
        (result) {
          switch (result) {
            case Ok(:final value):
              _log.debug('.fetch | result: $value');
              if (value.isNotEmpty) {
                final row = value.first;
                return _fromRow(row);
              } else {
                _valid = false;
                return Err(Failure(message: 'PurchaseProduct.fetch | Error: PurchaseProduct with id = $id - is not found', stackTrace: StackTrace.current));
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
  // ///
  // ///
  // Future<Result<Map<String, dynamic>, Failure>> removeOrder() {
  //   return setOrder(count: 0);
  // }
  // ///
  // ///
  // Future<Result<Map<String, dynamic>, Failure>> setOrder({required int count}) {
  //   return PurchaseSetOrder(
  //     userId: customer_id,
  //   //   DataSet<Map<String, dynamic>>(
  //   //     params: ApiParams({
  //   //       'tableName': 'order',
  //   //     }),
  //   //     apiRequest: ApiRequest(
  //   //       url: (count <= 0)
  //   //         ? 'https://u1489690.isp.regruhosting.ru/remove-order'
  //   //         : 'https://u1489690.isp.regruhosting.ru/add-order',
  //   //     ),
  //   //   ),
  //   ).send('$count', purchase_content_id, product_id, purchase_id);
  // }
  ///
  ///
  Future<Result<PurchaseProduct, Failure>> refresh() {
  // Future<DataObject> refresh() {
    return fetch();
      // params: {
      //   'customer/id': _userId,
      //   'purchase/id': '${this['purchase/id']}',
      //   'purchase_content/id': _purchaseContentId,
      // },
    // );
  }
}
///
/// The SQL parameters for the PurchaseProduct
class PurchaseProductSqlParams {
  final String? id;
  final String? purchaseId;
  final String? purchaseContentId;
  final String? customerId;
  PurchaseProductSqlParams({
    this.id,
    this.purchaseId,
    this.purchaseContentId,
    this.customerId,
  });
}
