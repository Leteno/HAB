import 'package:flutter/cupertino.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite_tile.dart';

class GameSpriteWidgetData {
  double posX;
  double posY;
  double widgetWidth;
  double widgetHeight;
  GameTileData tileData;
  late State _state;

  GameSpriteWidgetData(
      this.tileData, this.posX, this.posY, this.widgetWidth, this.widgetHeight);

  bindState(State state) {
    _state = state;
  }

  update() {
    if (_state != null) {
      _state.setState(() {});
    }
  }
}
