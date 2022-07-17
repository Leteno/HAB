import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/physic/direction.dart';
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
    int endXIndex = (right / map.gridSizeX).floor();
    int startYIndex = (top / map.gridSizeY).floor();
    int endYIndex = (bottom / map.gridSizeY).floor();

    for (int y = startYIndex; y <= endYIndex; y++) {
      if (y < 0 || y >= map.rowCount) {
        return true;
      }
      for (int x = startXIndex; x <= endXIndex; x++) {
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

  /*
   * Assume current sprite is not collision with map.
   * Now we have offset(dx, dy), if not collision we shall return
   * empty CollisionResult with isCollision:false
   * 
   * If we have collision, we need to calculate the CollisionResult for
   * how many offset we need to step back.
   */
  CollisionResult detectCollision(GameMap map, double offsetLeft,
      double offsetTop, Sprite sprite, Offset offset) {
    double horizontalCorrection = 0;
    double verticalCorrection = 0;

    Rect area = sprite.getCollisionArea();
    double left = area.left - offsetLeft;
    double top = -offsetTop + area.top;
    double right = left + area.width;
    double bottom = top + area.height;

    int startXIndex = (left / map.gridSizeX).floor();
    int endXIndex = (right / map.gridSizeX).floor();
    int startYIndex = (top / map.gridSizeY).floor();
    int endYIndex = (bottom / map.gridSizeY).floor();

    int newStartXIndex = ((left + offset.dx) / map.gridSizeX).floor();
    int newEndXIndex = ((right + offset.dx) / map.gridSizeX).floor();
    int newStartYIndex = ((top + offset.dy) / map.gridSizeY).floor();
    int newEndYIndex = ((bottom + offset.dy) / map.gridSizeY).floor();

    if (offset.dx > 0 && newEndXIndex != endXIndex) {
      int neareastBlock = 0;
      for (int y = startYIndex; y <= endYIndex; y++) {
        neareastBlock =
            min(map.nearestBlock(endXIndex, y, Direction.RIGHT), neareastBlock);
      }
      double maxXOffset = map.gridSizeX * (endXIndex + 1) - right;
      horizontalCorrection = min(maxXOffset, offset.dx) - offset.dx;
    } else if (offset.dx < 0 && newStartXIndex != startXIndex) {
      int neareastBlock = 0;
      for (int y = startYIndex; y <= endYIndex; y++) {
        neareastBlock = max(
            map.nearestBlock(startXIndex, y, Direction.LEFT), neareastBlock);
      }
      double maxXOffset = map.gridSizeX * startXIndex - left;
      horizontalCorrection = max(maxXOffset, offset.dx) - offset.dx;
    }

    if (offset.dy > 0 && newEndYIndex != endYIndex) {
      int neareastBlock = 0;
      for (int x = startXIndex; x <= endXIndex; x++) {
        neareastBlock =
            min(map.nearestBlock(x, endYIndex, Direction.DOWN), neareastBlock);
      }
      double maxYOffset = map.gridSizeY * (endYIndex + 1) - bottom;
      verticalCorrection = min(maxYOffset, offset.dy) - offset.dy;
    } else if (offset.dy < 0 && newStartYIndex != startYIndex) {
      int neareastBlock = 0;
      for (int x = startXIndex; x <= endXIndex; x++) {
        neareastBlock = max(
            map.nearestBlock(x, startYIndex, Direction.DOWN), neareastBlock);
      }
      double maxYOffset = map.gridSizeY * startYIndex - top;
      verticalCorrection = max(maxYOffset, offset.dy) - offset.dy;
    }

    return CollisionResult(Offset(horizontalCorrection, verticalCorrection));
  }
}

class _Position {
  int x;
  int y;
  _Position(this.x, this.y);
}

class CollisionResult {
  Offset correction;

  bool get isCollision => correction.dx != 0 || correction.dy != 0;
  CollisionResult(this.correction);
}
