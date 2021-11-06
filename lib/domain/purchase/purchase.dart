import 'package:flowers_app/domain/core/entities/convert.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/purchase/purchase_status.dart';

class Purchase extends DataObject{
  // bool _valid = true;
  late String id;
  // String? name;
  // String? details;
  // String? description;
  // String? preview;
  // PurchaseStatusText? status;
  // DateTime? started;
  // DateTime? ended;
  // DateTime? created;
  // DateTime? updated;
  // DateTime? deleted;

  Purchase({
    required this.id, 
  });
  // bool valid() {
  //   //TODO Purchase valid method to be implemented
  //   return _valid;
  // }
  // Purchase.fromRow(dynamic r) {
  //   _valid = true;
  //   final convert = const Convert().toPresentation;
  //   try {
  //     id = r['id'];
  //     name = convert(r['name']);
  //     details = convert(r['details']);
  //     description = convert(r['description']);
  //     preview = r['preview'] != null
  //       ? (r['preview'] ?? '')
  //         .split('<*>')
  //         .map((el) => ' ▪︎ $el\n')
  //         .join()
  //       : '';
  //     status = convert(r['status'], type: PurchaseStatus);
  //     started = convert(r['ended'], type: DateTime);
  //     ended = convert(r['ended'], type: DateTime);
  //     created = convert(r['created'], type: DateTime);
  //     updated = convert(r['updated'], type: DateTime);
  //     deleted = convert(r['deleted'], type: DateTime);
  //   } catch (e) {
  //     print('Ошибка при конвертации Purchase:\n$e');
  //     _valid = false;
  //   }
  // }

  // @override
  // Future<Purchase> fetch() {
  //   // TODO: implement fetch
  //   throw UnimplementedError(
  //     'Метод fetch() не реализован для класса Purchase'
  //   );
  // }
}
