import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/domain/core/entities/data_object.dart';
import 'package:flowers_app/domain/core/entities/value_string.dart';
import 'package:flowers_app/infrastructure/api/responce.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';

class RegisterUser {
  final DataSet<Map> _remote;
  final String _group;
  final String _location;
  final String _name;
  final String _phone;
  @override
  RegisterUser({
    required DataSet<Map> remote,
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
  Future<Response<Map>> fetch() async {
    int errCount = 0;
    String errDump = '';
    Map data = {};
    return Response<Map>(
      errCount: errCount, 
      errDump: errDump, 
      data: data
    );
  }
  // }
  // void _dispatch() async {
  //   print('[PurchaseList._dispatch]');
  //   //TODO Implement _dispatch method of User class
  // }
}