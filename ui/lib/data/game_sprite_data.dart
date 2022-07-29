import 'package:flutter/cupertino.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite_tile.dart';

class GameSpriteWidgetData {
  double posX;
  double posY;
  double widgetWidth;
  double widgetHeight;
  GameTileData tileData;
  late State? _state;

  bool jumpFlag = true;

  GameSpriteWidgetData(
      this.tileData, this.posX, this.posY, this.widgetWidth, this.widgetHeight);

  bindState(State state) {
    _state = state;
  }

  fakeStateForTest() {
    _state = null;
  }

  update() {
    if (_state != null) {
      _state!.setState(() {});
    }
  }

  Rect getCenteredCollisionArea() {
    return Rect.fromLTWH(
        posX +
            widgetWidth *
                (1.0 - tileData.tileActualWidth / tileData.tileWidth) /
                2,
        posY +
            widgetHeight *
                (1.0 - tileData.tileActualHeight / tileData.tileHeight) /
                2,
        widgetWidth * tileData.tileActualWidth / tileData.tileWidth,
        widgetHeight * tileData.tileActualHeight / tileData.tileHeight);
  }
}
