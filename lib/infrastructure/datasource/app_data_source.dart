import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

DataSource dataSource = DataSource({
  'client': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'client',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-client',
    ),
  ),
  'purchase': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'purchase_preview',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-view',
    ),
  ),
  'purchase_content': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'purchase_content_preview',
      // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-view',
    ),
  ),
  'purchase_product': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      // 'tableName': 'purchase_content_preview',
      // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-purchase-product',
    ),
  ),
  ///
  /// список заказов для личного кабинета пользователя
  'order_list': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'orderView',
      // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-view',
    ),
  ),
  ///
  /// список сообщений для личного кабинета пользователя
  ///  id - идентификатор записи одного оповещения
  ///  purchase_id - идентификатор закупки для которой запрошены оповещения
  ///  purchase_content_id - идентификатор позиции закупки для которой запрошены оповещения
  'notice_list': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      // 'id': 'id',
      // 'purchase_id': 'purchase_id',
      // 'purchase_content_id': 'purchase_content_id',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/get-notice-list',
    ),
  ),
  'set_order': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'order',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/set-data',
    ),
  ),
  'remove_order': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'order',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/set-data',
    ),
  ),
  'set_client': DataSet<Map<String, dynamic>>(
    params: ApiParams(const <String, dynamic>{
      'tableName': 'client',
    }),
    apiRequest: const ApiRequest(
      url: 'http://u1489690.isp.regruhosting.ru/set-client',
    ),
  ),
});
