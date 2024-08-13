import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/settings/setting.dart';
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
  final PurchaseContentSqlAccess _remote;
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

}
