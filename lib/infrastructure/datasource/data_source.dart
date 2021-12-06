import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class DataSource {
  final Map<String, DataSet> dataSets;
  const DataSource(this.dataSets);
  DataSet<T> dataSet<T>(String name) {
    if (dataSets.containsKey(name)) {
      final dataSet = dataSets[name];
        return dataSet as DataSet<T>;
    }
    throw Failure.dataSource(
      message: 'Ошибка в методе $runtimeType.dataSet(): $name - несуществующий DataSet',
      stackTrace: StackTrace.current,
    );
  }
}
