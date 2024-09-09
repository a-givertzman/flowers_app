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
  late String customerId = '';
  late String purchase_id = '';
  late String product_id = '';
  late String purchase = '';
  late String product_name = '';
  late String product_details = '';
  late String product_picture = '';
  late String product_description = '';
  late String sale_price = '';
  late String sale_currency = '';
  /// Доставка за единицу
  late String shipping = '';
  /// количество единиц товара в заказе пользователя 
  late int count = 0;
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
    required this.customerId,
    required String purchaseContentId,
    PurchaseProductSqlAccess? remote,
  }) : 
    id = purchaseContentId,
    _remote = remote ?? _sqlAccess();
  ///
  ///
  static PurchaseProductSqlAccess _sqlAccess() {
    return SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        _log.debug('.sqlBuilder | Building SQL with purchase_content_id: ${params?.id},  customer_id: ${params?.customerId}');
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
            JOIN product p ON puc.product_id = p.id
          where customer_id = ${params?.customerId} 
          and cord.id = ${params?.id};
        """,);
        // if (params?.customerId != null) {
        // } else {
        //   _log.warning('.sqlBuilder | Building SQL with id ${params?.customerId}, customer id not used');
        //   return Sql(sql: 'select * from purchase_content_view where id = $purchaseContentId;');
        // }
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
  /// Returns [count] as Ok(int) if parsed else Err()
  int parseCount(String value) {
    final count = int.tryParse(value);
    if (count != null) {
      return count;
    }
    _log.warning(".parseCount | Error parsing count from '$value'");
    return 0;
  }
  ///
  /// Returns Order parsed from database row Map<String, dynamic>
  PurchaseProduct.fromRow(Map<String, dynamic> row): _remote = _sqlAccess() {
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
      product_details = '${row['details']}';
      product_description = '${row['description']}';
      product_picture = '${row['picture']}';
      count = parseCount('${row['count']}');
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
  Future<Result<PurchaseProduct, Failure>> fetch(PurchaseProductSqlParams params) {
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
                return Err(Failure(message: 'PurchaseProduct.fetch | Error: PurchaseProduct with purchase_content_id: ${params.id},  customer_id: ${params.customerId} - Not found', stackTrace: StackTrace.current));
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
  Future<Result<PurchaseProduct, Failure>> refresh() {
    return fetch(
      PurchaseProductSqlParams(
        id: id,
        customerId: customerId,
      ),
    );
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
  final String? customerId;
  PurchaseProductSqlParams({
    this.id,
    this.purchaseId,
    this.customerId,
  });
}
