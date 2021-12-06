// ignore_for_file: avoid_print

void log(Object? m1, [Object? m2, Object? m3, Object? m4]) {
  final String s1 = m1 != null ? m1.toString() : '';
  final String s2 = m2 != null ? m2.toString() : '';
  final String s3 = m3 != null ? m3.toString() : '';
  final String s4 = m4 != null ? m4.toString() : '';
  assert(
    () {
      try {
        print(s1 + s2 + s3 + s4);
      } catch (e) {
        throw Exception('Ошибка в методе log(): $e');
      }
      return true;
    }(),
    'Только в отладке',
  );
}
