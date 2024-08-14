import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class PurchaseContentSqlParams {
  final String? clientId;
  final String? purchaseId;
  final String? purchaseContentId;
  PurchaseContentSqlParams({
    this.clientId,
    this.purchaseId,
    this.purchaseContentId,
  });
}
///
///
typedef PurchaseContentSqlAccess = SqlAccess<Map<String, dynamic>, PurchaseContentSqlParams>;
///
/// Класс реализует список элементов PurchaseProduct
/// список позиций в составе закупки для каталога
class PurchaseContent {
  static const _log = Log('PurchaseContent');
  final PurchaseContentSqlAccess _remote;
  final Map<String, PurchaseProduct> _products = {};
  ///
  ///
  PurchaseContent({
    PurchaseContentSqlAccess? remote,
  }): 
    _remote = remote ?? SqlAccess(
      address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
      authToken: const Setting('api-auth-token').toString(),
      database: const Setting('api-database').toString(),
      sqlBuilder: (sql, params) {
        return Sql(sql: 'select * from purchase_content_preview where purchase_id = ${params?.purchaseId};');
      },
      entryBuilder: (row) {
        return row;
      },
    );
            // id: purchase.id,
            // remote: DataSet(
            //   params: ApiParams({
            //     'tableName': 'purchase_content_preview',
            //     'where': [{'operator': 'where', 'field': 'purchase/id', 'cond': '=', 'value': purchase.id}],
            //   }),
            //   apiRequest: const ApiRequest(
            //     url: 'http://u1489690.isp.regruhosting.ru/get-view',
            //   ),
            // ),
            // dataMaper: (row) => PurchaseProduct(
            //   userId: user.id,
            //   purchaseContentId: '${row['id']}', // purchase_content_id
            //   remote: dataSource.dataSet('purchase_product'),
            // ).fromRow(row),
  ///
  /// Returns PurchaseProduct's as map
  Future<Result<Map<String, PurchaseProduct>, Failure>> refresh() => fetch();
  ///
  /// Returns PurchaseProduct's as map
  Future<Result<Map<String, PurchaseProduct>, Failure>> fetch() {
    _products.clear();
    return _remote.fetch().then(
      (result) {
        switch (result) {
          case Ok(value :final result):
            _log.debug('.fetch | result: $result');
            if (result.isNotEmpty) {
              for (final row in result) {
                final product = PurchaseProduct.fromRow(row);
                _products.putIfAbsent(product.id, () => product);
              }
            }
              return Ok(_products);
          case Err(:final error):
            _log.warning('.fetch | Error: $error');
            return Err(Failure(message: 'OrderList.fetch | Error: $error', stackTrace: StackTrace.current));
        }
      },
      onError: (err) {
        _log.warning('.fetch | Error: $err');
        return Err(Failure(message: 'OrderList.fetch | Error: $err', stackTrace: StackTrace.current));
      },
    );
  }
}
