// ignore_for_file: avoid_print

void log(Object? message1, [Object? message2, Object? message3, Object? message4]) {
  final String s1 = message1 != null ? message1.toString() : '';
  final String s2 = message2 != null ? message2.toString() : '';
  final String s3 = message3 != null ? message3.toString() : '';
  final String s4 = message4 != null ? message4.toString() : '';
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
