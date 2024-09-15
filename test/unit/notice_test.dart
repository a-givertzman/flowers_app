import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Notice() creating test', () {
    final notice = Notice(
      viewed: Future.value(false),
    );
    expect(notice.isValid, equals(true));
  });
  test('Notice.empty() creating test', () {
    final notice = Notice.empty();
    expect(notice.isValid, equals(false));
  });
}
