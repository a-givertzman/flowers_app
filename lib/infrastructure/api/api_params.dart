import 'dart:convert';

class ApiParams {
  final Map _map;
  ApiParams(Map params): _map = Map.from(params) {
    _map['procedureName'] =  _map['procedureName'] ?? '';
    _map['tableName'] = _map['tableName'] ?? '';
    _map['params'] = _map['params'] ?? '0';
    _map['keys'] = _map['keys'] ?? ['*'];
    _map['groupBy'] = _map['groupBy'] ?? '';
    _map['orderBy'] = _map['orderBy'] ?? 'id';
    _map['order'] = _map['order'] ?? 'ASC';
    _map['where'] = _map['where'] ?? [];
    _map['limit'] = _map['limit'] ?? 0;
  }
  ApiParams updateWith(Map params) {
    final newParams = Map.from(_map);
    params.forEach((key, value) {
      newParams[key] = value;
    });
    return ApiParams(newParams);
  }
  Map<String, String> toMap() {
    final Map<String, String> map = {};
    _map.forEach((key, value) {
      map['$key'] = json.encode(value);
    });
    return map;
  }
}
