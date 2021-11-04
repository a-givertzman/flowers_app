import 'package:flowers_app/domain/purchase/purchase_status.dart';

class Purchase {
  final String id;
  final String name;
  final String details;
  final String description;
  final String preview;
  final PurchaseStatus status;
  final DateTime? started;
  final DateTime? ended;
  final DateTime created;
  final DateTime updated;
  final DateTime? deleted;

  const Purchase({
    required this.id, 
    required this.name, 
    required this.details, 
    required this.description, 
    required this.preview, 
    required this.status, 
    required this.started, 
    required this.ended, 
    required this.created, 
    required this.updated, 
    this.deleted,
  });
  bool valid() {
    //TODO Purchase valid method to be implemented
    return true;
  }
}