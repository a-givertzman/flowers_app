import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Notice() creating test', () {
    final notice = Notice(
      remote: dataSource.dataSet('notice_list'),
      viewed: Future.value(false),
    );
    expect(notice.isEmpty, equals(false));
  });
  test('Notice.empty() creating test', () {
    final notice = Notice.empty();
    expect(notice.isEmpty, equals(true));
  });
}
