import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/tile_position.dart';

class Map01 {
  late BulkSpriteController _MapController;
  final double gridSizeX;
  final double gridSizeY;
  late final GameMap _gameMap;
  Map01(posX, posY, this.gridSizeX, this.gridSizeY) {
    _MapController = BulkSpriteController(16, 16, gridSizeX, gridSizeY);
    _MapController.posX = posX * 1.0;
    _MapController.posY = posY * 1.0;
    _MapController.tiles =
        TilePosition.initMap(_positions.toList(), 16, 16, 384, 544, 16, 16);

    _gameMap = GameMap(_positions.toList(), 16, 16, gridSizeX, gridSizeY);
    _gameMap.getBlockTypeFunc = _getGridTypeFunction;
    _gameMap.setExitPoint(0, 3, () {
      goBack();
    }, isVirtualIndex: true);
    _gameMap.setExitPoint(0, 15, () {
      goNext();
    }, isVirtualIndex: true);
  }

  @override
  Widget build() {
    return BulkSpriteTile('images/background_tile.png', _MapController);
  }

  GameMap gameMap() {
    return _gameMap;
  }

  @override
  Rect getCollisionArea() {
    return Rect.fromLTWH(_MapController.posX, _MapController.posY,
        _MapController.destWidth, _MapController.destHeight);
  }

  void goBack() {
    print("Go back");
  }

  void goNext() {
    print("Go Next");
  }
}

GameGridType _getGridTypeFunction(int blockValue) {
  if (blockValue == 0) {
    return GameGridType.EMPTY;
  } else if (blockValue == 468 || blockValue == 465 || blockValue == 470) {
    return GameGridType.BUSH;
  } else if (blockValue == 719 || blockValue == 718) {
    return GameGridType.OBJECT;
  } else if (blockValue == 362) {
    return GameGridType.FIRE;
  }
  return GameGridType.BLOCK;
}

List<int> _positions = [
  0,
  0,
  62,
  62,
  62,
  62,
  62,
  62,
  61,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  14,
  14,
  0,
  0,
  11,
  11,
  11,
  11,
  11,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  14,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  14,
  0,
  14,
  14,
  0,
  0,
  0,
  0,
  0,
  14,
  14,
  14,
  14,
  14,
  14,
  14,
  14,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  470,
  37,
  0,
  0,
  0,
  14,
  14,
  14,
  0,
  14,
  14,
  14,
  14,
  14,
  14,
  14,
  14,
  37,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  718,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  14,
  14,
  0,
  0,
  0,
  0,
  0,
  14,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  0,
  8,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  37,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  14,
  37,
  0,
  0,
  0,
  80,
  0,
  0,
  719,
  0,
  0,
  0,
  0,
  14,
  14,
  14,
  37,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  20,
  0,
  0,
  0,
  465,
  465,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  14,
  14,
  14,
  14,
  14,
  14,
  14,
  20,
  20,
  20,
  362,
  362,
  362,
  362,
  362,
  362
];
