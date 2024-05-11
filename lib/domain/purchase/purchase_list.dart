import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/purchase/purchase.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов Purchase для PurchaseOverview
/// Список закупок для отображения в катологе 
class PurchaseList extends DataCollection<Purchase>{
  PurchaseList({
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    remote: remote,
    dataMaper: dataMaper,
  );
}
