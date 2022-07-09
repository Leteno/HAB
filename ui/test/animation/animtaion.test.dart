import 'package:flutter_test/flutter_test.dart';
import 'package:ui/animation/animation.dart';

void main() {
  test('test animation', () {
    IntAnimation anim = IntAnimation(1000, 1, 10);
    expect(anim.value, 1);
    expect(anim.isStop(), false);
    anim.elapse(100000);
    expect(anim.value, 10);
    expect(anim.isStop(), true);
  });

  test('test animation time elapse', () {
    IntAnimation anim = IntAnimation(1000, 1, 11);
    expect(anim.value, 1);
    anim.elapse(100);
    expect(anim.value, 2);
    anim.elapse(100);
    expect(anim.value, 3);
    expect(anim.isStop(), false);
    anim.elapse(400);
    expect(anim.value, 7);
    anim.elapse(400);
    expect(anim.value, 11);
    anim.elapse(400);
    expect(anim.value, 11);
    expect(anim.isStop(), true);
  });

  test('test animation callback', () {
    int value = 0;
    IntAnimation anim = IntAnimation(1000, 1, 11);
    anim.onValueChange = (v) => value = v;

    // as the anim hasn't started, the value is 0
    expect(value, 0);

    anim.elapse(100);
    expect(value, 2);
    anim.elapse(100);
    expect(anim.isStop(), false);
    expect(value, 3);
    anim.elapse(400);
    expect(value, 7);
    anim.elapse(400);
    expect(value, 11);
    anim.elapse(400);
    expect(value, 11);
    expect(anim.isStop(), true);
  });

  test('test double animation', () {
    DoubleAnimation anim = DoubleAnimation(1000, 1, 11);
    expect(anim.value, 1);
    anim.elapse(100);
    expect(anim.value, 2);
    anim.elapse(100);
    expect(anim.value, 3);
    expect(anim.isStop(), false);
    anim.elapse(400);
    expect(anim.value, 7);
    anim.elapse(350);
    expect(anim.value, 10.5);
    anim.elapse(400);
    expect(anim.value, 11);
    expect(anim.isStop(), true);
  });

  test('test double animation', () {
    DoubleAnimation anim = DoubleAnimation(1000, 1, 11);
    double value = 0;
    anim.onValueChange = (v) => value = v;

    // as the anim hasn't started, the value is 0
    expect(value, 0);

    anim.elapse(100);
    expect(value, 2);
    anim.elapse(100);
    expect(value, 3);
    anim.elapse(400);
    expect(value, 7);
    expect(anim.isStop(), false);
    anim.elapse(350);
    expect(value, 10.5);
    anim.elapse(400);
    expect(value, 11);
    expect(anim.isStop(), true);
  });
}
