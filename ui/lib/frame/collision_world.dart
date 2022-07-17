import 'package:flutter/widgets.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/sprite.dart';

class CollisionWorld {
  // this will correct collision
  bool testCollision(
      GameMap map, double offsetLeft, double offsetTop, Sprite sprite) {
    Rect area = sprite.getCollisionArea();
    double left = area.left - offsetLeft;
    double top = -offsetTop + area.top;
    double right = left + area.width;
    double bottom = top + area.height;

    int startXIndex = (left / map.gridSizeX).floor();
    int endXIndex = (right / map.gridSizeX).ceil();
    int startYIndex = (top / map.gridSizeY).floor();
    int endYIndex = (bottom / map.gridSizeY).ceil();

    for (int y = startYIndex; y < endYIndex; y++) {
      if (y < 0 || y >= map.rowCount) {
        return true;
      }
      for (int x = startXIndex; x < endXIndex; x++) {
        if (x < 0 || x >= map.columnCount) {
          return true;
        }
        if (map.isOccupy(x, y)) {
          return true;
        }
      }
    }
    return false;
  }
}
