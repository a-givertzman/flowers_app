import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class PurchaseList extends DataCollection{
  PurchaseList({
    required String id,
    required DataSet remote,
    required Function(dynamic) dataMaper,
  }) 
  :super(
    id: id, remote: remote, dataMaper: dataMaper,
  );
}
