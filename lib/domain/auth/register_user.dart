import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class RegisterUser {
  final DataSet<Map<String, dynamic>> _remote;
  final String _group;
  final String _location;
  final String _name;
  final String _phone;
  @override
  RegisterUser({
    required DataSet<Map<String, dynamic>> remote,
    required String group,
    required String location,
    required String name,
    required String phone,
  }) :
    _remote = remote,
    _group = group,
    _location = location,
    _name = name,
    _phone = phone;
  Future<Response<Map<String, dynamic>>> fetch() async {
    final fieldData = {
      'group': _group,
      'location': _location,
      'name': _name,
      'phone': _phone,
    };
    return _remote.fetchWith(
      params: {
        'fieldData': fieldData,
      },
    )
      .then((response) {
        log('[RegisterUser.fetch] response:', response);
        return Response(
          errCount: (response.data().isNotEmpty) 
            ? 0 
            : 1, 
          errDump: (response.data().isNotEmpty) 
            ? '' 
            : 'Ошибка регистрации нового пользователя: ${response.errorMessage()}', 
          data: response.data(),
        );
      })
      .onError((error, stackTrace) {
        log('Ошибка в методе $runtimeType.fetchWith: $error');
        return Response(
          errCount: 1, 
          errDump: 'Ошибка в методе $runtimeType.fetchWith: $error',
          data: {},
        );
      });
  }
}
