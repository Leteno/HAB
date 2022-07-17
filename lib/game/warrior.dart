import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:hab_repo/data/warrior_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Warrior extends Sprite {
  late GameSpriteWidgetData widgetData;
  Warrior(super.posX, super.posY, super.widgetWidth, super.widgetHeight,
      super.spriteWidth, super.spriteHeight) {
    widgetData = GameSpriteWidgetData(
        WarriorTileData(), posX, posY, widgetWidth, widgetHeight);
  }

  @override
  Widget build() {
    return SpriteTile(
      imageSrc: widgetData.tileData.imagePath,
      widgetData: widgetData,
    );
  }

  void moveRight() {
    posX = widgetData.posX += 1;
    widgetData.update();

    IntAnimation animation = IntAnimation(1000, 1, 6);
    animation.onValueChange = (value) {
      if (value == 6) {
        value = 1;
      }
      widgetData.tileData.imageSpriteIndexX = value;
      widgetData.update();
    };
    if (!animationMap.containsKey('human')) {
      animationMap['human'] = animation;
    }
  }

  void jump() {
    DoubleAnimation animation = DoubleAnimation(2000, 0, 100);
    double originalPoxY = widgetData.posY;
    animation.onValueChange = (value) {
      posY = widgetData.posY = originalPoxY - value;
      widgetData.update();
    };
    animation.onStop = () {
      DoubleAnimation animation = DoubleAnimation(2000, 100, 0);
      animation.onValueChange = ((value) {
        posY = widgetData.posY = originalPoxY - value;
        widgetData.update();
      });
      animationMap['human'] = animation;
    };
    animationMap['human'] = animation;
  }

  @override
  Rect getCollisionArea() {
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
