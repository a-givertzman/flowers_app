import 'package:flowers_app/domain/core/errors/failure.dart';

class PurchaseStatus {
  static const prepare = 'prepare';
  static const active = 'active';
  static const purchase = 'purchase';
  static const distribute = 'distribute';
  static const archived = 'archived';
  static const canceled = 'canceled';
  static const notsampled = 'notsampled';
}
class PurchaseStatusText {
  final Map<String, String> _statuses = {
    PurchaseStatus.prepare: 'Подготовка',
    PurchaseStatus.active: 'Сбор заказов',
    PurchaseStatus.purchase: 'Закупка товара',
    PurchaseStatus.distribute: 'Раздача товара',
    PurchaseStatus.archived: 'В архиве',
    PurchaseStatus.canceled: 'Отменена',
    PurchaseStatus.notsampled: 'Не определен',
  };
  final String _status;
  PurchaseStatusText({required String status}): _status = status;
  String text() => textOf(_status);
  String textOf(String key) {
    if (_statuses.containsKey(key)) {
      final status = _statuses[key];
      if (status != null) {
        return status;
      }
    }
    throw Failure.unexpected(
      message: '[$runtimeType] $key - несуществующая группа',
      stackTrace: StackTrace.current,
    );
  }
}
