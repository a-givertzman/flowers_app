import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class PurchaseList extends DataCollection{
  PurchaseList({
    // required String id,
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    // id: id, 
    remote: remote,
    dataMaper: dataMaper,
  );
}
