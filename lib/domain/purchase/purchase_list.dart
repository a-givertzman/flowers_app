import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

class PurchaseList {
  final DataSource dataSource;
  // final DataSet dataSet;
  const PurchaseList({
    required this.dataSource,
    // required this.dataSet,
  });
  Future<List<Purchase>> getList(DataSet dataSet) async {
    return dataSet.getData()
      .then(
        (data) {
          List<Purchase> purchaseList = [];
          for (final row in data) {
            purchaseList.add(
              Purchase(
                id: row['id'], 
                name: row['name'] ?? '', 
                details: row['details'] ?? '', 
                description: row['description'] ?? '', 
                preview: row['preview'] != null
                  ? (row['preview'] ?? '')
                    .split('<*>')
                    .map((el) => ' ▪︎ $el\n')
                    .join()
                  : '',
                status: PurchaseStatus(status: row['status'] ?? 'prepare'), 
                started: row['ended'] != null ? DateTime.parse(row['started']) : null, 
                ended: row['ended'] != null ? DateTime.parse(row['ended']) : null, 
                created: DateTime.parse(row['created']),
                updated: DateTime.parse(row['updated']),
                deleted: row['deleted'] != null ? DateTime.parse(row['deleted']) : null,
              )
            );
          }
          return purchaseList;
        }
      )
      .catchError((e) {
        //TODO PurchaseList error handling to be implemented
        throw Exception(e);
      });
  }
}
