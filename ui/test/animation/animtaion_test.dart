import 'package:flutter_test/flutter_test.dart';
import 'package:ui/animation/animation.dart';

void main() {
  test('test animation', () {
    IntAnimation anim = IntAnimation(1000, 1, 10);
    bool callOnStop = false;
    anim.onStop = () {
      callOnStop = true;
    };
    expect(anim.value, 1);
    expect(anim.isStop(), false);
    expect(callOnStop, false);
    anim.elapse(100000);
    expect(anim.value, 10);
    expect(anim.isStop(), true);
    expect(callOnStop, true);
  });

  test('test animation time elapse', () {
    IntAnimation anim = IntAnimation(1000, 1, 11);
    bool callOnStop = false;
    anim.onStop = () {
      callOnStop = true;
    };
    expect(anim.value, 1);
    anim.elapse(100);
    expect(anim.value, 2);
    anim.elapse(100);
    expect(anim.value, 3);
    expect(anim.isStop(), false);
    expect(callOnStop, false);
    anim.elapse(400);
    expect(anim.value, 7);
    anim.elapse(400);
    expect(anim.value, 11);
    anim.elapse(400);
    expect(anim.value, 11);
    expect(anim.isStop(), true);
    expect(callOnStop, true);
  });

  test('test animation callback', () {
    int value = 0;
    IntAnimation anim = IntAnimation(1000, 1, 11);
    anim.onValueChange = (v) => value = v;
    bool callOnStop = false;
    anim.onStop = () {
      callOnStop = true;
    };

    // as the anim hasn't started, the value is 0
    expect(value, 0);

    anim.elapse(100);
    expect(value, 2);
    anim.elapse(100);
    expect(anim.isStop(), false);
    expect(callOnStop, false);
    expect(value, 3);
    anim.elapse(400);
    expect(value, 7);
    anim.elapse(400);
    expect(value, 11);
    anim.elapse(400);
    expect(value, 11);
    expect(anim.isStop(), true);
    expect(callOnStop, true);
  });

  test('test double animation', () {
    DoubleAnimation anim = DoubleAnimation(1000, 1, 11);
    bool callOnStop = false;
    anim.onStop = () {
      callOnStop = true;
    };
    expect(anim.value, 1);
    anim.elapse(100);
    expect(anim.value, 2);
    anim.elapse(100);
    expect(anim.value, 3);
    expect(anim.isStop(), false);
    expect(callOnStop, false);
    anim.elapse(400);
    expect(anim.value, 7);
    anim.elapse(350);
    expect(anim.value, 10.5);
    anim.elapse(400);
    expect(anim.value, 11);
    expect(anim.isStop(), true);
    expect(callOnStop, true);
  });

  test('test double animation', () {
    DoubleAnimation anim = DoubleAnimation(1000, 1, 11);
    double value = 0;
    anim.onValueChange = (v) => value = v;
    bool callOnStop = false;
    anim.onStop = () {
      callOnStop = true;
    };

    // as the anim hasn't started, the value is 0
    expect(value, 0);

    anim.elapse(100);
    expect(value, 2);
    anim.elapse(100);
    expect(value, 3);
    anim.elapse(400);
    expect(value, 7);
    expect(anim.isStop(), false);
    expect(callOnStop, false);
    anim.elapse(350);
    expect(value, 10.5);
    anim.elapse(400);
    expect(value, 11);
    expect(anim.isStop(), true);
    expect(callOnStop, true);
  });

  test('test next animation', () {
    DoubleAnimation animation1 = DoubleAnimation(1000, 0, 10);
    DoubleAnimation animation2 = DoubleAnimation(1000, 100, 200);
    animation1.next(animation2);

    double value1 = animation1.begin;
    animation1.onValueChange = (value) {
      value1 = value;
    };
    double value2 = animation2.begin;
    animation2.onValueChange = (value) {
      value2 = value;
    };

    animation1.elapse(500);
    expect(value1, 5);
    expect(value2, 100);

    animation1.elapse(500);
    expect(value1, 10);
    expect(value2, 100);

    animation1.elapse(500);
    expect(value1, 10);
    expect(value2, 150);

    animation1.elapse(500);
    expect(value1, 10);
    expect(value2, 200);
  });
}
