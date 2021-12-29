import 'package:flowers_app/domain/order/order.dart';

class OrderHeader {
  late String purchaseId;
  late String purchaseName;
  OrderHeader({
    required Order order, 
  }) {
    purchaseId = '${order['purchase/id']}';
    purchaseName = '${order['purchase/name']}';
  }
}
