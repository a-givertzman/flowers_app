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
  final status;
  PurchaseStatusText({required this.status});
  String name(String key) {
    final status = _statuses[key];
    if (status == null) {
      final classInst = runtimeType.toString();
      throw Exception('[$classInst] $key - несуществующий статус');
    }
    return status;
  }
}
