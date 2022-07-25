import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:hab_repo/data/warrior_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Warrior extends Sprite {
  Warrior(collisionWorld, posX, posY, widgetWidth, widgetHeight)
      : super(
            GameSpriteWidgetData(WarriorTileData(), posX * 1.0, posY * 1.0,
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

  @override
  void onIdle() {
    AnimationData data = widgetData.tileData.getAnimationData(SpriteState.IDLE);
    IntAnimation animation = data.buildAnimation(800, widgetData.tileData, () {
      widgetData.update();
    });
    animationMap['idle'] = animation;
  }
}
