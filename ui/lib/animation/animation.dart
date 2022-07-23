typedef OnValueChangeFunction<T> = void Function(T value);
typedef OnStopFunction = void Function();

abstract class Animation<T extends num> {
  int duration;
  late int left;
  T begin;
  T end;
  late T value;
  Animation(this.duration, this.begin, this.end) {
    left = duration;
    value = begin;
  }

  OnValueChangeFunction<T>? onValueChange;
  OnStopFunction? onStop;

  void elapse(int time);

  bool isStop() {
    return left == 0;
  }

  void reset() {
    left = duration;
    value = begin;
  }
}

class DoubleAnimation extends Animation<double> {
  DoubleAnimation(super.duration, super.begin, super.end);

  @override
  void elapse(int time) {
    left -= time;
    if (left <= 0) {
      left = 0;
      value = end;
      onValueChange?.call(end);
      onStop?.call();
    }
    value = ((duration - left) * (end - begin) / duration + begin);
    onValueChange?.call(value);
  }
}

class IntAnimation extends Animation<int> {
  IntAnimation(super.duration, super.begin, super.end);

  @override
  void elapse(int time) {
    left -= time;
    if (left <= 0) {
      left = 0;
      value = end;
      onValueChange?.call(end);
      onStop?.call();
    }
    value = ((duration - left) * (end - begin) / duration + begin).round();
    onValueChange?.call(value);
  }
}
