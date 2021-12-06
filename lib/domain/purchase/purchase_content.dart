import 'package:flowers_app/domain/core/entities/data_collection.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

/// Класс реализует список продуктов в закупке
/// 
/// Бедет создан с id  и удаленным источником данных
/// при вызове метода fetch будет читать записи из источника
/// и формировать из каждой записи экземпляр класса PurchaseProduct
class PurchaseContent extends DataCollection{//extends DataObject{
  PurchaseContent({
    // required String id,
    required DataSet<Map<String, dynamic>> remote,
    required DataObject Function(Map<String, dynamic>) dataMaper,
  }): super(
    // id: id, 
    remote: remote, 
    dataMaper: dataMaper,
  );
}
