import 'dart:convert';

// import 'dart:html';

class ApiRequestParams {
  final String? procedureName;
  final String? tableName;
  final String? params;
  final List? keys;
  final String? groupBy;
  final String? orderBy;
  final String? order;
  final List? where;
  final int? limit;
  const ApiRequestParams({
    this.procedureName,
    this.tableName,
    this.params,
    this.keys,
    this.groupBy,
    this.orderBy,
    this.order,
    this.where,
    this.limit,
  });
  // FormData getFormData() {
  //   // dPrint.log('[ApiRequest._prepareData]');
  //   final formData = FormData();
  //   formData.append("procedureName", json.encode(procedureName ?? ''));
  //   formData.append("tableName", json.encode(tableName ?? ''));
  //   formData.append("params", json.encode(params ?? '0'));
  //   formData.append("keys", json.encode(keys ?? ['*']));
  //   formData.append("groupBy", json.encode(groupBy ?? ''));
  //   formData.append("orderBy", json.encode(orderBy ?? 'id'));
  //   formData.append("order", order ?? 'ASC');
  //   formData.append("where", json.encode(where ?? []));
  //   formData.append("limit", json.encode(limit ?? 0));
  //   return formData;
  // }
  Map<String, String> getMap() {
    // dPrint.log('[ApiRequest._prepareData]');
    final Map<String, String> map = {};
    map["procedureName"] = json.encode(procedureName ?? '');
    map["tableName"] = json.encode(tableName ?? '');
    map["params"] = json.encode(params ?? '0');
    map["keys"] = json.encode(keys ?? ['*']);
    map["groupBy"] = json.encode(groupBy ?? '');
    map["orderBy"] = json.encode(orderBy ?? 'id');
    map["order"] = json.encode(order ?? 'ASC');
    map["where"] = json.encode(where ?? []);
    map["limit"] = json.encode(limit ?? 0);
    return map;
  }
}
