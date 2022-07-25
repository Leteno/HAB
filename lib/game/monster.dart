import 'package:flutter/widgets.dart';
import 'package:hab_repo/data/mouse_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Monster extends Sprite {
  Monster(collisionWorld, posX, posY, widgetWidth, widgetHeight)
      : super(
            GameSpriteWidgetData(MouseTileData(), posX * 1.0, posY * 1.0,
                widgetWidth * 1.0, widgetHeight * 1.0),
            collisionWorld);

  @override
  Widget build() {
    return SpriteTile(
      widgetData: widgetData,
    );
  }

  @override
  Rect getCollisionArea() {
    return getCenteredCollisionArea();
  }
}
