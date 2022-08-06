import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/physic/direction.dart';
import 'package:ui/physic/math.dart';
import 'package:ui/sprite/sprite.dart';

import '../data/game_sprite_data.dart';

enum GameGridType {
  EMPTY,
  BLOCK,
  BUSH,
  FIRE,
  OBJECT,
}

typedef GetGridTypeFunction = GameGridType Function(int blockValue);

class GameMap {
  List<int> mapData;
  int rowCount;
  int columnCount;
  double gridSizeX;
  double gridSizeY;
  late List<List<int>> virtualMapData;
  late int vRowCount, vColumnCount;
  late GetGridTypeFunction getBlockTypeFunc;
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

    getBlockTypeFunc = defaultGetBlockType;
  }

  GameGridType defaultGetBlockType(int blockValue) {
    return blockValue != 0 ? GameGridType.BLOCK : GameGridType.EMPTY;
  }

  // Whether this block is occupied and nobody could pass it,
  // according to its value.
  bool isGridOccupied(int gridValue) {
    return getBlockTypeFunc(gridValue) == GameGridType.BLOCK;
  }

  // We want to know whether current sprite has collictions with the object
  // in map.
  // touchIncluded: if true, we will also see the block that are contiguous with.
  List<GameGridType> getCollisionType(GameSpriteWidgetData widgetData,
      {bool touchIncluded = false}) {
    List<GameGridType> result = [];
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
    if (!touchIncluded) {
      if (Math.isSameInMath(endXIndex * gridSizeX, area.right)) {
        endXIndex--;
      }
      if (Math.isSameInMath(endYIndex * gridSizeY, area.bottom)) {
        endYIndex--;
      }
    }

    // To virtual map coordinate, (x+1, y+1)
    int vStartXIndex = startXIndex + 1;
    int vEndXIndex = endXIndex + 1;
    int vStartYIndex = startYIndex + 1;
    int vEndYIndex = endYIndex + 1;

    for (int y = vStartYIndex; y <= vEndYIndex; y++) {
      for (int x = vStartXIndex; x <= vEndXIndex; x++) {
        GameGridType type = getBlockTypeFunc(virtualMapData[y][x]);
        if (!result.contains(type)) {
          result.add(type);
        }
      }
    }
    return result;
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
        if (isGridOccupied(mapData[i + y * columnCount])) {
          return i - x;
        }
      }
      return -x;
    } else if (direction == Direction.RIGHT) {
      for (int i = x + 1; i < columnCount; i++) {
        if (isGridOccupied(mapData[i + y * columnCount])) {
          return i - x;
        }
      }
      return columnCount - 1 - x;
    } else if (direction == Direction.UP) {
      for (int i = y - 1; i >= 0; i--) {
        if (isGridOccupied(mapData[x + i * columnCount])) {
          return i - y;
        }
      }
      return -y;
    } else if (direction == Direction.DOWN) {
      for (int i = y + 1; i < rowCount; i++) {
        if (isGridOccupied(mapData[x + i * columnCount])) {
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
    if (Math.isSameInMath(endXIndex * gridSizeX, area.right)) {
      endXIndex--;
    }
    if (Math.isSameInMath(endYIndex * gridSizeY, area.bottom)) {
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
        if (isGridOccupied(virtualMapData[y][x])) {
          break;
        }
        if (standGround && !isGridOccupied(virtualMapData[y + 1][x])) {
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
        if (isGridOccupied(virtualMapData[y][x])) {
          break;
        }
        if (standGround && !isGridOccupied(virtualMapData[y + 1][x])) {
          // break if we need standGround and the block bellow is empty
          break;
        }
        gridCount++;
      }
      rightAtMostGridCount = min(rightAtMostGridCount, gridCount);
    }
    // Here, area.right >= gridSizeX * endXIndex
    double rightAtLeastOffset = gridSizeX - area.right % gridSizeX;
    if (Math.isSameInMath(rightAtLeastOffset, gridSizeX)) {
      rightAtLeastOffset = 0;
    }
    region.rightAtMostOffset =
        rightAtLeastOffset + rightAtMostGridCount * gridSizeX;

    return region;
  }

  double fallingDistance(GameSpriteWidgetData widgetData) {
    Rect area = widgetData.getCenteredCollisionArea();

    int startXIndex = (area.left / gridSizeX).floor();
    int endXIndex = (area.right / gridSizeX).floor();
    int endYIndex = (area.bottom / gridSizeY).floor();

    // if (area.right, area.bottom) is percisely in grid boundary,
    // endXIndex/endYIndex would be real number + 1.
    // Such as (20, 20, 20, 20) in grid 20x20.
    // it should be percisely position(1, 1)
    // However, here would calcuated as (1,1)~(2,2)
    // Here we do a small correction here.
    if (Math.isSameInMath(endXIndex * gridSizeX, area.right)) {
      endXIndex--;
    }
    if (Math.isSameInMath(endYIndex * gridSizeY, area.bottom)) {
      endYIndex--;
    }

    // To virtual map coordinate, (x+1, y+1)
    int vStartXIndex = startXIndex + 1;
    int vEndXIndex = endXIndex + 1;
    int vEndYIndex = endYIndex + 1;

    int gridBelowAtMost = vRowCount;
    for (int x = vStartXIndex; x <= vEndXIndex; x++) {
      int gridCount = 0;
      for (int y = vEndYIndex + 1; y < vRowCount; y++) {
        if (isGridOccupied(virtualMapData[y][x])) {
          break;
        }
        gridCount++;
      }
      gridBelowAtMost = min(gridBelowAtMost, gridCount);
    }
    double atLeastOffset = gridSizeY - area.bottom % gridSizeY;
    if (Math.isSameInMath(atLeastOffset, gridSizeY)) {
      atLeastOffset = 0;
    }
    return atLeastOffset + gridBelowAtMost * gridSizeY;
  }

  bool hasCollision(GameSpriteWidgetData widgetData) {
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
    if (Math.isSameInMath(endXIndex * gridSizeX, area.right)) {
      endXIndex--;
    }
    if (Math.isSameInMath(endYIndex * gridSizeY, area.bottom)) {
      endYIndex--;
    }
    // To virtual map coordinate, (x+1, y+1)
    int vStartXIndex = startXIndex + 1;
    int vEndXIndex = endXIndex + 1;
    int vStartYIndex = startYIndex + 1;
    int vEndYIndex = endYIndex + 1;

    for (int y = vStartYIndex; y <= vEndYIndex; y++) {
      for (int x = vStartXIndex; x <= vEndXIndex; x++) {
        if (isGridOccupied(virtualMapData[y][x])) {
          return true;
        }
      }
    }
    return false;
  }
}

class WonderingRegion {
  double leftAtMostOffset = 0;
  double rightAtMostOffset = 0;
}
