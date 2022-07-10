import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/keyboard/game_event.dart';

void main() {
  test('test keyboard', () {
    expect(
        GameEvent.translate(const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.arrowUp,
            logicalKey: LogicalKeyboardKey.arrowUp,
            timeStamp: Duration())),
        GameEventType.UP);
    expect(
        GameEvent.translate(const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.arrowDown,
            logicalKey: LogicalKeyboardKey.arrowDown,
            timeStamp: Duration())),
        GameEventType.DOWN);
    expect(
        GameEvent.translate(const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.arrowLeft,
            logicalKey: LogicalKeyboardKey.arrowLeft,
            timeStamp: Duration())),
        GameEventType.LEFT);
    expect(
        GameEvent.translate(const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.arrowRight,
            logicalKey: LogicalKeyboardKey.arrowRight,
            timeStamp: Duration())),
        GameEventType.RIGHT);
    expect(
        GameEvent.translate(const KeyDownEvent(
            physicalKey: PhysicalKeyboardKey.space,
            logicalKey: LogicalKeyboardKey.space,
            timeStamp: Duration())),
        GameEventType.JUMP);
  });
}
