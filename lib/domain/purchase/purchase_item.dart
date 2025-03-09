import 'package:ext_rw/ext_rw.dart';
import 'package:flower_app/domain/purchase/purchase_status.dart';
import 'package:flower_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
/// The SQL parameters for the PurchaseItem
class PurchaseItemSqlParams {
  final String? id;
  final String? purchaseId;
  PurchaseItemSqlParams({
    this.id,
    this.purchaseId,
  });
}
///
///
typedef PurchaseitemSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseItemSqlParams>;
///
/// Item of the PurchaseContent
class PurchaseItem {
  static const _log = Log('PurchaseItem');
  /// purchase_item -> id
  late String id = '';
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
  /// количество количество единиц товара в закупке (остаток)
  late int remains = 0;
  late PurchaseStatus status = PurchaseStatus.notCampled();
  late String created = '';
  late String updated = '';
  late String deleted = '';
  final PurchaseitemSqlAccess? _remote;
  bool _valid = false;
  ///
  ///
  PurchaseItem({
    required this.id,
    PurchaseitemSqlAccess? remote,
  }) : 
    _remote = remote ?? _sqlAccess(id: id);
  ///
  ///
  static PurchaseitemSqlAccess _sqlAccess({String? id}) {
    return SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        if (params?.id != null) {
          if (params?.purchaseId != null) {
            _log.debug('.sqlBuilder | Building SQL with id: ${params?.id},  purchase_id: ${params?.purchaseId}');
            return Sql(sql: "select * from purchase_item_view where id = ${params?.id} and pirchase_id = ${params?.purchaseId};");
          }
          _log.debug('.sqlBuilder | Building SQL with id: ${params?.id}');
          return Sql(sql: "select * from purchase_item_view where id = ${params?.id};");
        }
        _log.debug('.sqlBuilder | Building SQL with id: $id');
        return Sql(sql: "select * from purchase_item_view where id = $id;");
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
  int _parseInt(String value) {
    final count = int.tryParse(value);
    if (count != null) {
      return count;
    }
    _log.warning(".parseInt | Error parsing '$value'");
    return 0;
  }
  ///
  /// Returns Order parsed from database row `Map<String, dynamic>`
  PurchaseItem.fromRow(Map<String, dynamic> row): _remote = _sqlAccess() {
    _fromRow(row);
  }
  ///
  ///
  Result<PurchaseItem, Failure> _fromRow(Map<String, dynamic> row) {
    _log.debug("._fromRow |");
    final rowId = row['id'];
    if (rowId == null || '$rowId'.isEmpty) {
      _valid = false;
      return Err(Failure(message: 'PurchaseItem._fromRow | Error: PurchaseItem invalid "id" in row: $row', stackTrace: StackTrace.current));
    } else {
      // if ('$rowId'.isEmpty) {
      //   _valid = false;
      //   return Err(Failure(message: 'PurchaseItem._fromRow | Error: PurchaseItem invalid "id" in row: $row', stackTrace: StackTrace.current));
      // }
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
      remains = _parseInt('${row['remains']}');
      status = PurchaseStatus(status: '${row['status']}');
      created = '${row['created']}';
      updated = '${row['updated']}';
      deleted = '${row['deleted']}';
      _valid = true;
      _log.debug("._fromRow | Done");
      return Ok(this);
    }    
  }
  ///
  /// Returns PurchaseItem by it database ID
  Future<Result<PurchaseItem, Failure>> fetch(PurchaseItemSqlParams params) {
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
                return Err(Failure(message: 'PurchaseItem.fetch | Error: PurchaseItem with purchase_item_id: ${params.id},  purchase_id: ${params.purchaseId} - Not found', stackTrace: StackTrace.current));
              }
            case Err(:final error):
              _log.warning('.fetch | Error: $error');
              _valid = false;
              return Err(Failure(message: 'PurchaseItem.fetch | Error: $error', stackTrace: StackTrace.current));
          }
        },
        onError: (err) {
          _log.warning('.fetch | Error: $err');
          _valid = false;
          return Err(Failure(message: 'PurchaseItem.fetch | Error: $err', stackTrace: StackTrace.current));
        },
      );
    } else {
      _valid = false;
      return Future.value(Err(Failure(message: 'PurchaseItem.fetch | Error: _remote is not initilized', stackTrace: StackTrace.current)));
    }
  }
  ///
  ///
  Future<Result<PurchaseItem, Failure>> refresh() {
    return fetch(
      PurchaseItemSqlParams(id: id),
    );
  }
}
