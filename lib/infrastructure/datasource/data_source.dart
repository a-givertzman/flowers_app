import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class DataSource {
  final Map<String, DataSet> dataSets;
  const DataSource(this.dataSets);
  DataSet dataSet(String name) {
    final dataSet = dataSets[name];
    if (dataSet == null) {
      throw Exception('[DataSource] $name - несуществующий DataSet');
    }
    return dataSet;
  }
}
