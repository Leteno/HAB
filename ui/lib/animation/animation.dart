typedef OnValueChangeFunction<T> = void Function(T value);
typedef OnStopFunction = void Function();

abstract class Animation<T extends num> {
  int duration;
  late int left;
  T begin;
  T end;
  late T value;

  Animation<T>? _nextAnimation;
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

  void forceStop() {
    left = 0;
    performOnStop();
  }

  void reset() {
    left = duration;
    value = begin;
  }

  void performOnStop() {
    onStop?.call();
    // TODO(juzhen) Actually we need to run:
    // _nextAnimation.animate(restOfTheTime);
    if (_nextAnimation != null) {
      copy(_nextAnimation!);
    }
  }

  void next(Animation<T> nextAnimation) {
    _nextAnimation = nextAnimation;
  }

  void copy(Animation<T> animation) {
    duration = animation.duration;
    left = animation.left;
    begin = animation.begin;
    end = animation.end;
    value = animation.value;
    onValueChange = animation.onValueChange;
    onStop = animation.onStop;
    _nextAnimation = animation._nextAnimation;
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
      performOnStop();
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
      performOnStop();
    }
    value = ((duration - left) * (end - begin) / duration + begin).round();
    onValueChange?.call(value);
  }
}
