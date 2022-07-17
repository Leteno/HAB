import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:hab_repo/data/warrior_tile_data.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
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
    if (collisionWorld.testCollision(this)) {
      widgetData.posX += 1;
    } else {
      widgetData.update();
    }

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

  void moveRight() {
    widgetData.posX += 1;
    if (collisionWorld.testCollision(this)) {
      widgetData.posX -= 1;
    } else {
      widgetData.update();
    }

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
      double previous = widgetData.posY;
      widgetData.posY = originalPoxY - value;
      if (collisionWorld.testCollision(this)) {
        widgetData.posY = previous;
      } else {
        widgetData.update();
      }
    };
    animation.onStop = () {
      DoubleAnimation animation = DoubleAnimation(2000, 100, 0);
      animation.onValueChange = ((value) {
        double previous = widgetData.posY;
        widgetData.posY = originalPoxY - value;
        if (collisionWorld.testCollision(this)) {
          widgetData.posY = previous;
        } else {
          widgetData.update();
        }
      });
      animationMap['human'] = animation;
    };
    animationMap['human'] = animation;
  }

  @override
  Rect getCollisionArea() {
    return getCenteredCollisionArea();
  }
}
