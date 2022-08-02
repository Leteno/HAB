import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/tile_position.dart';

class SimpleMap {
  late BulkSpriteController _MapController;
  final double gridSizeX;
  final double gridSizeY;
  late final GameMap _gameMap;
  SimpleMap(posX, posY, this.gridSizeX, this.gridSizeY) {
    _MapController = BulkSpriteController(16, 16, gridSizeX, gridSizeY);
    _MapController.posX = posX * 1.0;
    _MapController.posY = posY * 1.0;
    _MapController.tiles =
        TilePosition.initMap(_positions.toList(), 16, 16, 384, 544, 8, 8);

    _gameMap = GameMap(_positions.toList(), 8, 8, gridSizeX, gridSizeY);
    _gameMap.getBlockTypeFunc = _getGridTypeFunction;
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
}

GameGridType _getGridTypeFunction(int blockValue) {
  if (blockValue == 0) {
    return GameGridType.EMPTY;
  } else if (blockValue == 468 || blockValue == 465) {
    return GameGridType.BUSH;
  }
  return GameGridType.BLOCK;
}

List<int> _positions = [
  468,
  468,
  349,
  0,
  0,
  0,
  0,
  465,
  349,
  349,
  349,
  0,
  0,
  349,
  349,
  349,
  349,
  0,
  0,
  0,
  468,
  0,
  0,
  0,
  349,
  349,
  349,
  349,
  349,
  349,
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
  349,
  349,
  349,
  0,
  0,
  0,
  465,
  0,
  349,
  0,
  0,
  0,
  349,
  349,
  349,
  349,
  349,
  0,
  0
];
