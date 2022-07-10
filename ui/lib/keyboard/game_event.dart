import 'package:flutter/services.dart';

enum GameEventType { LEFT, RIGHT, UP, DOWN, JUMP, UNKNOWN }

class GameEvent {
  static GameEventType translate(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      return GameEventType.LEFT;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      return GameEventType.RIGHT;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      return GameEventType.UP;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return GameEventType.DOWN;
    }
    if (event.logicalKey == LogicalKeyboardKey.space) {
      return GameEventType.JUMP;
    }
    return GameEventType.UNKNOWN;
  }
}
