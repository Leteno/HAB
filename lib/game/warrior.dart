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
  CollisionWorld collisionWorld;
  Warrior(this.collisionWorld, posX, posY, widgetWidth, widgetHeight)
      : super(GameSpriteWidgetData(WarriorTileData(), posX * 1.0, posY * 1.0,
            widgetWidth * 1.0, widgetHeight * 1.0));

  @override
  Widget build() {
    return SpriteTile(
      widgetData: widgetData,
    );
  }

  void moveLeft() {
    widgetData.posX -= 1;
    if (collisionWorld.hasCollision(this)) {
      widgetData.posX += 1;
    } else {
      widgetData.update();
    }

    widgetData.tileData.reverseDirection = true;
    AnimationData data =
        widgetData.tileData.getAnimationData(SpriteState.WALKING);
    IntAnimation animation = data.buildAnimation(1000, widgetData.tileData, () {
      widgetData.update();
    });
    if (!animationMap.containsKey('human')) {
      animationMap['human'] = animation;
    }
  }

  void moveRight() {
    widgetData.posX += 1;
    if (collisionWorld.hasCollision(this)) {
      widgetData.posX -= 1;
    } else {
      widgetData.update();
    }

    widgetData.tileData.reverseDirection = false;
    AnimationData data =
        widgetData.tileData.getAnimationData(SpriteState.WALKING);
    IntAnimation animation = data.buildAnimation(1000, widgetData.tileData, () {
      widgetData.update();
    });
    if (!animationMap.containsKey('human')) {
      animationMap['human'] = animation;
    }
  }

  void jump() {
    AnimationData data = widgetData.tileData.getAnimationData(SpriteState.JUMP);
    IntAnimation jumpGraphicAnimation =
        data.buildAnimation(2000, widgetData.tileData, () {
      widgetData.update();
    });

    DoubleAnimation movingAnimation = DoubleAnimation(2000, 0, 100);
    double originalPoxY = widgetData.posY;
    movingAnimation.onValueChange = (value) {
      double previous = widgetData.posY;
      widgetData.posY = originalPoxY - value;
      if (collisionWorld.hasCollision(this)) {
        widgetData.posY = previous;
      } else {
        widgetData.update();
      }
    };
    movingAnimation.onStop = () {
      widgetData.jumpFlag = true;
    };
    animationMap['human'] = movingAnimation;
    animationMap['jump'] = jumpGraphicAnimation;
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
