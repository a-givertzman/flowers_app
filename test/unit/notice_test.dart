import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/settings/setting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Notice() creating test', () {
    final notice = Notice(
      remote: SqlAccess(
        address: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
        authToken: const Setting('api-auth-token').toString(),
        database: const Setting('api-database').toString(),
        sqlBuilder: (sql, userPhone) {
          return Sql(sql: "select * from notice;");
        },
        entryBuilder: (row) {
          return row;
        },
      ),
      viewed: Future.value(false),
    );
    expect(notice.isValid, equals(true));
  });
  test('Notice.empty() creating test', () {
    final notice = Notice.empty();
    expect(notice.isValid, equals(false));
  });
}
