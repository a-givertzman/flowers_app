
import 'package:flowers_app/dev/log/log.dart';

void main() {
  const _debug = false;
  const key = '1234';
  final lKey = _escape(key).split(',');  // use escape() so only have single-byte chars to encode
  final k = [];
  k.length = lKey.length;
  for (var i = 0; i < lKey.length; i++) {
    final keySlice = lKey[i];//str4ToLong(keySlice);
    k[i] = keySlice;
  }
  log(_debug, 'k: $k');
  alg(k);
}

void alg(List k) {
  const _debug = false;
  var y = 1;
  var z = 2;
  const delta = 0x9E3779B9;
  const limit = delta * 32;
  var sum = 0;
  while (sum != limit) {
    final add1 = int.parse('${k[sum & 3]}');
    final z4 = z << 4;
    final z5 = z >>> 5;
    final zsum = z ^ sum;
    final z4z5 = z4 ^ z5;
    y += ((z << 4) ^ (z >>> 5)) + zsum + add1;
    // y += (z << 4 ^ z >>> 5) + z ^ sum + add1;
    sum += delta;
    final add2 = int.parse('${k[sum >>> 11 & 3]}');
    final y4 = y << 4;
    final y5 = y >>> 5;
    final ysum = y ^ sum;
    final y4y5 = y4 ^ y5;
    // print('encode add1: $add1');
    log(_debug, 'encode z: $z;   z4: $z4;   z5: $z5;   z4z5: $z4z5;   zsum: $zsum');
    log(_debug, 'encode y: $y;   y4: $y4;   y5: $y5;   y4y5: $y4y5;   ysum: $ysum');
    log(_debug, 'encode add1: $add1;   add2: $add2');
    z += ((y << 4) ^ (y >>> 5)) + ysum + add2;
    // note: unsigned right-shift '>>>' is used in place of original '>>', due to lack
    // of 'unsigned' type declaration in JavaScript (thanks to Karsten Kraus for this)
  }
  log(_debug, 'encode y: $y;   z: $z');
}

String _escape(String str) {
  return str.split('').map((c) => c.codeUnitAt(0)).join(',');
}
