import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/physic/direction.dart';
import 'package:ui/sprite/sprite.dart';

class CollisionWorld {
  late GameMap _map;
  double extraOffsetLeft = 0;
  double extraOffsetTop = 0;
  List<Sprite> observers = [];

  bindGameMap(GameMap map) {
    _map = map;
  }

  bool hasCollision(Sprite sprite) {
    return _map.hasCollision(sprite.widgetData);
  }

  void addObserver(Sprite sprite) {
    if (observers.contains(sprite)) return;
    observers.add(sprite);
    assert(observers.length < 32);
  }

  void removeObserver(Sprite sprite) {
    observers.remove(sprite);
  }

  void detectCollisionForObservers() {
    for (int i = 0; i < observers.length; i++) {
      for (int j = i + 1; j < observers.length; j++) {
        if (_detectCollisionForObjects(observers[i], observers[j])) {
          observers[i].onCollissionWith(observers[j]);
          observers[j].onCollissionWith(observers[i]);
          continue;
        }
      }
    }
  }

  bool _detectCollisionForObjects(Sprite obj1, Sprite obj2) {
    Rect rect1 = obj1.getCenteredCollisionArea();
    Rect rect2 = obj2.getCenteredCollisionArea();
    return rect1.overlaps(rect2);
  }

  // Deprecated: use hasCollision instead.
  // this will correct collision
  bool testCollision(Sprite sprite) {
    Rect area = sprite.getCollisionArea();
    double left = area.left - extraOffsetLeft;
    double top = -extraOffsetTop + area.top;
    double right = left + area.width;
    double bottom = top + area.height;

    int startXIndex = (left / _map.gridSizeX).floor();
    int endXIndex = (right / _map.gridSizeX).floor();
    int startYIndex = (top / _map.gridSizeY).floor();
    int endYIndex = (bottom / _map.gridSizeY).floor();

    for (int y = startYIndex; y <= endYIndex; y++) {
      if (y < 0 || y >= _map.rowCount) {
        return true;
      }
      for (int x = startXIndex; x <= endXIndex; x++) {
        if (x < 0 || x >= _map.columnCount) {
          return true;
        }
        if (_map.isOccupy(x, y)) {
          return true;
        }
      }
    }
    return false;
  }

  /*
   * Assume current sprite is not collision with _map.
   * Now we have offset(dx, dy), if not collision we shall return
   * empty CollisionResult with isCollision:false
   * 
   * If we have collision, we need to calculate the CollisionResult for
   * how many offset we need to step back.
   */
  CollisionResult detectCollision(Sprite sprite, Offset offset) {
    double horizontalCorrection = 0;
    double verticalCorrection = 0;

    Rect area = sprite.getCollisionArea();
    double left = area.left - extraOffsetLeft;
    double top = -extraOffsetTop + area.top;
    double right = left + area.width;
    double bottom = top + area.height;

    int startXIndex = (left / _map.gridSizeX).floor();
    int endXIndex = (right / _map.gridSizeX).floor();
    int startYIndex = (top / _map.gridSizeY).floor();
    int endYIndex = (bottom / _map.gridSizeY).floor();

    int newStartXIndex = ((left + offset.dx) / _map.gridSizeX).floor();
    int newEndXIndex = ((right + offset.dx) / _map.gridSizeX).floor();
    int newStartYIndex = ((top + offset.dy) / _map.gridSizeY).floor();
    int newEndYIndex = ((bottom + offset.dy) / _map.gridSizeY).floor();

    if (offset.dx > 0 && newEndXIndex != endXIndex) {
      int neareastBlock = 0;
      for (int y = startYIndex; y <= endYIndex; y++) {
        neareastBlock = min(
            _map.nearestBlock(endXIndex, y, Direction.RIGHT), neareastBlock);
      }
      double maxXOffset = _map.gridSizeX * (endXIndex + 1) - right;
      horizontalCorrection = min(maxXOffset, offset.dx) - offset.dx;
    } else if (offset.dx < 0 && newStartXIndex != startXIndex) {
      int neareastBlock = 0;
      for (int y = startYIndex; y <= endYIndex; y++) {
        neareastBlock = max(
            _map.nearestBlock(startXIndex, y, Direction.LEFT), neareastBlock);
      }
      double maxXOffset = _map.gridSizeX * startXIndex - left;
      horizontalCorrection = max(maxXOffset, offset.dx) - offset.dx;
    }

    if (offset.dy > 0 && newEndYIndex != endYIndex) {
      int neareastBlock = 0;
      for (int x = startXIndex; x <= endXIndex; x++) {
        neareastBlock =
            min(_map.nearestBlock(x, endYIndex, Direction.DOWN), neareastBlock);
      }
      double maxYOffset = _map.gridSizeY * (endYIndex + 1) - bottom;
      verticalCorrection = min(maxYOffset, offset.dy) - offset.dy;
    } else if (offset.dy < 0 && newStartYIndex != startYIndex) {
      int neareastBlock = 0;
      for (int x = startXIndex; x <= endXIndex; x++) {
        neareastBlock = max(
            _map.nearestBlock(x, startYIndex, Direction.DOWN), neareastBlock);
      }
      double maxYOffset = _map.gridSizeY * startYIndex - top;
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
