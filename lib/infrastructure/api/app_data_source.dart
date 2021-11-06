import 'package:flowers_app/infrastructure/api/api_params.dart';
import 'package:flowers_app/infrastructure/api/api_request.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/infrastructure/datasource/data_source.dart';

DataSource dataSource = DataSource({
    'purchase': DataSet(
      name: 'purchase', 
      params: ApiParams(
        tableName: 'purchase_preview',
        // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
      ),
      apiRequest: const ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/public/api/getView.php',
      ),
    ),
    'purchase_content': DataSet(
      name: 'purchase_content', 
      params: ApiParams(
        tableName: 'purchaseContentView',
        // where: [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': 1}]
      ),
      apiRequest: const ApiRequest(
        url: 'http://u1489690.isp.regruhosting.ru/public/api/getView.php',
      ),
    ),
  });