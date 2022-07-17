import 'package:flutter/widgets.dart';
import 'package:hab_repo/data/mouse_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Monster extends Sprite {
  Monster(posX, posY, widgetWidth, widgetHeight)
      : super(GameSpriteWidgetData(MouseTileData(), posX * 1.0, posY * 1.0,
            widgetWidth * 1.0, widgetHeight * 1.0));

  void moveRight() {
    widgetData.posX += 1;
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
      widgetData: widgetData,
    );
  }

  @override
  Rect getCollisionArea() {
    return getCenteredCollisionArea();
  }
}
