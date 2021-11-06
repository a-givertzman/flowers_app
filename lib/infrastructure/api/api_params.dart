import 'dart:collection';
import 'dart:convert';

// import 'dart:html';

class ApiParams {
  final String? procedureName;
  final String? tableName;
  final String? params;
  final List? keys;
  final String? groupBy;
  final String? orderBy;
  final String? order;
  final List? where;
  final int? limit;
  ApiParams? updated;
  ApiParams({
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
  Map<String, String> getMap({ApiParams? newParams}) {
    // dPrint.log('[ApiRequest._prepareData]');
    final Map<String, String> map = {};
    map["procedureName"] = json.encode(updated?.procedureName ?? procedureName ?? '');
    map["tableName"] = json.encode(updated?.tableName ?? tableName ?? '');
    map["params"] = json.encode(updated?.params ?? params ?? '0');
    map["keys"] = json.encode(updated?.keys ?? keys ?? ['*']);
    map["groupBy"] = json.encode(updated?.groupBy ?? groupBy ?? '');
    map["orderBy"] = json.encode(updated?.orderBy ?? orderBy ?? 'id');
    map["order"] = json.encode(updated?.order ?? order ?? 'ASC');
    map["where"] = json.encode(updated?.where ?? where ?? []);
    map["limit"] = json.encode(updated?.limit ?? limit ?? 0);
    return map;
  }
  void update(ApiParams params) {
    updated = params;
  }
}
