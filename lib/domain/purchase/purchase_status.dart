import 'package:flowers_app/domain/core/errors/failure.dart';

/// Константы статусов закупок и позиций в закупке
class PurchaseStatusList {
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
  PurchaseStatusList.active,
];
/// Класс работы со статузами закупок и позиций закупок
class PurchaseStatus {
  final Map<String, String> _statuses = {
    PurchaseStatusList.prepare: 'Подготовка',
    PurchaseStatusList.active: 'Сбор заказов',
    PurchaseStatusList.purchase: 'Закупка товара',
    PurchaseStatusList.distribute: 'Раздача товара',
    PurchaseStatusList.archived: 'В архиве',
    PurchaseStatusList.canceled: 'Отменена',
    PurchaseStatusList.notsampled: 'Не определен',
  };
  late String _status;
  PurchaseStatus({required String status}) {
    _status = _statuses.containsKey(status) 
      ? status
      : PurchaseStatusList.notsampled;
      // : throw Failure.convertion(
      //     message: "[PurchaseStatusText] '$status' неизвестный статус",
      //     stackTrace: StackTrace.current,
      // );
  }
  /// вернет true если данный статус разрешает заказ товара
  bool onOrder() {
    return purchaseStatusOnOrder.contains(_status);
  }
  /// вернет значение статуса
  String get value => _status;
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
      message: '[$runtimeType] $status - неизвестный статус',
      stackTrace: StackTrace.current,
    );
  }
}
