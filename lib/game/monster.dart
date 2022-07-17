import 'package:flutter/widgets.dart';
import 'package:hab_repo/data/mouse_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Monster extends Sprite {
  late GameSpriteWidgetData widgetData;
  Monster(super.posX, super.posY, super.widgetWidth, super.widgetHeight,
      super.spriteWidth, super.spriteHeight) {
    widgetData = GameSpriteWidgetData(
        MouseTileData(), posX, posY, widgetWidth, widgetHeight);
  }

  void moveRight() {
    posX = widgetData.posX += 1;
    widgetData.update();
    IntAnimation animation = IntAnimation(1000, 1, 8);
    animation.onValueChange = (value) {
      if (value == 8) {
        value = 1;
      }
      widgetData.tileData.imageSpriteIndexX = value;
      widgetData.update();
    };
    if (!animationMap.containsKey('rat')) {
      animationMap['rat'] = animation;
    }
  }

  @override
  Widget build() {
    return SpriteTile(
      // TODO refactor
      imageSrc: widgetData.tileData.imagePath,
      widgetData: widgetData,
    );
  }

  @override
  Rect getCollisionArea() {
    // TODO refactor
    GameTileData tileData = widgetData.tileData;
    return Rect.fromLTWH(
        posX +
            widgetData.widgetWidth *
                (1.0 - tileData.tileActualWidth / tileData.tileWidth) /
                2,
        posY +
            widgetData.widgetHeight *
                (1.0 - tileData.tileActualHeight / tileData.tileHeight) /
                2,
        widgetWidth * tileData.tileActualWidth / tileData.tileWidth,
        widgetHeight * tileData.tileActualHeight / tileData.tileHeight);
  }
}
