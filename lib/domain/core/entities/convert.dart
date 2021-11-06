import 'package:flowers_app/domain/purchase/purchase_status.dart';

class Convert {
  const Convert();
  dynamic toPresentation(value, {type = String}) {
    switch (type) {
      case String:
        return value;
        break;
      case DateTime:
        return value != null 
          ? DateTime.tryParse(value) 
          : null;
        break;
      case PurchaseStatus:
        return value != null 
          ? PurchaseStatusText(status: value) 
          : PurchaseStatus.notsampled;
        break;
      default:
        return value.toString();
    }
  }
}