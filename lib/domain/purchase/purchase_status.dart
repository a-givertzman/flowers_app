class PurchaseStatus {
  final Map<String, String> _statuses = {
    'prepare': 'Подготовка',
    'active': 'Сбор заказов',
    'purchase': 'Закупка товара',
    'distribute': 'Раздача товара',
    'archived': 'В архиве',
    'canceled': 'Отменена',
  };
  final status;
  PurchaseStatus({required this.status});
  String name(String key) {
    final status = _statuses[key];
    if (status == null) {
      throw Exception('[PurchaseStatus] $key - несуществующий статус');
    }
    return status;
  }
}
