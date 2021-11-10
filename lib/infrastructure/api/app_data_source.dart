import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

DataSource dataSource = DataSource({
    'purchase': DataSet(
      params: ApiParams(const {
        'tableName': 'purchase_preview',
        // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
      }),
      apiRequest: const ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/get-view',
      ),
    ),
    'purchase_content': DataSet(
      params: ApiParams(const {
        'tableName': 'purchase_content_preview',
        // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
      }),
      apiRequest: const ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/get-view',
      ),
    ),
    'set_order': DataSet(
      params: ApiParams(const {
        'tableName': 'order',
      }),
      apiRequest: const ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/set-data',
      ),
    ),
  });