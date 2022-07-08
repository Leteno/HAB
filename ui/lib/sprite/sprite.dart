import 'package:flutter/widgets.dart';
import 'package:ui/sprite/sprite_tile.dart';

abstract class Sprite {
  Widget build();
  // updateLogic will call first, then it is updateUIIfNeeded
  void updateLogic(int elapseTime);
  void updateUIIfNeeded();
}
