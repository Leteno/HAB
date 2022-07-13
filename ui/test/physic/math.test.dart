import 'package:flutter_test/flutter_test.dart';
import 'package:ui/physic/math.dart';

void main() {
  test('Test math', () {
    expect(Math.between(0, 10, 0), true);
    expect(Math.between(0, 10, 1), true);
    expect(Math.between(0, 10, 9), true);
    expect(Math.between(0, 10, 10), true);
    expect(Math.between(0, 10, -1), false);
    expect(Math.between(0, 10, 11), false);
  });
}
