import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов PurchaseProduct
/// список позиций в составе закупки для каталога
class PurchaseContent extends DataCollection{//extends DataObject{
  PurchaseContent({
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    remote: remote, 
    dataMaper: dataMaper,
  );
}
