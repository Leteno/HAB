import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/physic/direction.dart';
import 'package:ui/physic/math.dart';
import 'package:ui/sprite/sprite.dart';

import '../data/game_sprite_data.dart';

class GameMap {
  List<int> mapData;
  int rowCount;
  int columnCount;
  double gridSizeX;
  double gridSizeY;
  late List<List<int>> virtualMapData;
  late int vRowCount, vColumnCount;
  GameMap(this.mapData, this.columnCount, this.rowCount, this.gridSizeX,
      this.gridSizeY) {
    // virtualMap will have an extra line in left/top/right/bottom four direction
    // around the original mapData.
    virtualMapData = [];
    vColumnCount = columnCount + 2;
    vRowCount = rowCount + 2;
    List<int> firstLine = [], lastLine = [];
    // The count should be original size + boundary left + boundary right
    for (int i = 0; i < vColumnCount; i++) {
      firstLine.add(-1);
      lastLine.add(-1);
    }
    virtualMapData.add(firstLine);
    // each line will contains boundary + real data + boundary
    for (int y = 0; y < rowCount; y++) {
      List<int> lineData = [-1];
      for (int x = 0; x < columnCount; x++) {
        lineData.add(mapData[x + y * columnCount]);
      }
      lineData.add(-1);
      virtualMapData.add(lineData);
    }
    virtualMapData.add(lastLine);
  }

  bool isOccupy(int x, int y) {
    assert(Math.between(0, columnCount - 1, x));
    assert(Math.between(0, rowCount - 1, y));

    return mapData[x + y * columnCount] > 0;
  }

  // Return the distance to nearest block.
  // return 0 if not exists.
  int nearestBlock(int x, int y, Direction direction) {
    assert(Math.between(0, columnCount, x));
    assert(Math.between(0, rowCount, y));

    if (direction == Direction.LEFT) {
      for (int i = x - 1; i >= 0; i--) {
        if (mapData[i + y * columnCount] > 0) {
          return i - x;
        }
      }
      return -x;
    } else if (direction == Direction.RIGHT) {
      for (int i = x + 1; i < columnCount; i++) {
        if (mapData[i + y * columnCount] > 0) {
          return i - x;
        }
      }
      return columnCount - 1 - x;
    } else if (direction == Direction.UP) {
      for (int i = y - 1; i >= 0; i--) {
        if (mapData[x + i * columnCount] > 0) {
          return i - y;
        }
      }
      return -y;
    } else if (direction == Direction.DOWN) {
      for (int i = y + 1; i < rowCount; i++) {
        if (mapData[x + i * columnCount] > 0) {
          return i - y;
        }
      }
      return rowCount - 1 - y;
    }
    return 0;
  }

  // Monster need wondering around the ground it stands
  // We need to calculate how many distance it could go left
  // how many distance it could go right.
  // return { 'left': 12, 'right': 12 }
  WonderingRegion getWonderingRegion(GameSpriteWidgetData widgetData,
      {bool standGround = false}) {
    WonderingRegion region = WonderingRegion();
    Rect area = widgetData.getCenteredCollisionArea();

    int startXIndex = (area.left / gridSizeX).floor();
    int endXIndex = (area.right / gridSizeX).floor();
    int startYIndex = (area.top / gridSizeY).floor();
    int endYIndex = (area.bottom / gridSizeY).floor();

    // if (area.right, area.bottom) is percisely in grid boundary,
    // endXIndex/endYIndex would be real number + 1.
    // Such as (20, 20, 20, 20) in grid 20x20.
    // it should be percisely position(1, 1)
    // However, here would calcuated as (1,1)~(2,2)
    // Here we do a small correction here.
    if (endXIndex * gridSizeX == area.right) {
      endXIndex--;
    }
    if (endYIndex * gridSizeY == area.bottom) {
      endYIndex--;
    }

    // To virtual map coordinate, (x+1, y+1)
    int vStartXIndex = startXIndex + 1;
    int vEndXIndex = endXIndex + 1;
    int vStartYIndex = startYIndex + 1;
    int vEndYIndex = endYIndex + 1;

    // Left at most
    int leftAtMostGridCount = vColumnCount;
    for (int y = vStartYIndex; y <= vEndYIndex; y++) {
      int gridCount = 0;
      for (int x = vStartXIndex - 1; x >= 0; x--) {
        if (virtualMapData[y][x] != 0) {
          break;
        }
        if (standGround && virtualMapData[y + 1][x] == 0) {
          // break if we need standGround and the block bellow is empty
          break;
        }
        gridCount++;
      }
      leftAtMostGridCount = min(leftAtMostGridCount, gridCount);
    }
    // Here, area.left >= gridSizeX * startXIndex
    double leftAtLeastOffset = area.left - gridSizeX * startXIndex;
    region.leftAtMostOffset =
        leftAtLeastOffset + leftAtMostGridCount * gridSizeX;

    // Right at most
    int rightAtMostGridCount = vColumnCount;
    for (int y = vStartYIndex; y <= vEndYIndex; y++) {
      int gridCount = 0;
      for (int x = vEndXIndex + 1; x < vColumnCount; x++) {
        if (virtualMapData[y][x] != 0) {
          break;
        }
        if (standGround && virtualMapData[y + 1][x] == 0) {
          // break if we need standGround and the block bellow is empty
          break;
        }
        gridCount++;
      }
      rightAtMostGridCount = min(rightAtMostGridCount, gridCount);
    }
    // Here, area.right >= gridSizeX * endXIndex
    double rightAtLeastOffset =
        (gridSizeX - area.right % gridSizeX) % gridSizeX; // TODO(juzhen) perf
    region.rightAtMostOffset =
        rightAtLeastOffset + rightAtMostGridCount * gridSizeX;

    return region;
  }
}

class WonderingRegion {
  double leftAtMostOffset = 0;
  double rightAtMostOffset = 0;
}
