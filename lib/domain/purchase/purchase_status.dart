import 'package:flowers_app/domain/core/errors/failure.dart';

/// Константы статусов закупок и позиций в закупке
class PurchaseStatus {
  static const prepare = 'prepare';
  static const active = 'active';
  static const purchase = 'purchase';
  static const distribute = 'distribute';
  static const archived = 'archived';
  static const canceled = 'canceled';
  static const notsampled = 'notsampled';
}
/// Статусы разрешающие заказ товара
const purchaseStatusOnOrder = [
  PurchaseStatus.active,
];
/// Класс работы со статузами закупок и позиций закупок
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
  late String _status;
  PurchaseStatusText({required String status}) {
    _status = _statuses.containsKey(status) 
      ? status
      : PurchaseStatus.notsampled;
      // : throw Failure.convertion(
      //     message: "[PurchaseStatusText] '$status' неизвестный статус",
      //     stackTrace: StackTrace.current,
      // );
  }
  /// вернет true если данный статус разрешает заказ товара
  bool onOrder() {
    return purchaseStatusOnOrder.contains(_status);
  }
  /// вернет текстовое представление статуса
  String text() => textOf(_status);
  /// вернет текстовое представление статуса переданного в параметре
  String textOf(String status) {
    if (_statuses.containsKey(status)) {
      final statusText = _statuses[status];
      if (statusText != null) {
        return statusText;
      }
    }
    throw Failure.unexpected(
      message: '[$runtimeType] $status - несуществующая группа',
      stackTrace: StackTrace.current,
    );
  }
}
