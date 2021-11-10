import 'package:flowers_app/domain/core/entities/data_collection.dart';

class PurchaseList extends DataCollection{
  PurchaseList({
    required id,
    required remote,
    required dataMaper,
  }) 
  :super(
    id: id, remote: remote, dataMaper: dataMaper
  );
}