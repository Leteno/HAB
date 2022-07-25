import 'package:flutter/widgets.dart' hide Animation;
import 'package:ui/animation/animation.dart'
    show Animation, DoubleAnimation, IntAnimation;
import 'package:ui/data/game_sprite_data.dart';

import '../data/game_tile_data.dart';
import '../frame/collision_world.dart';

abstract class Sprite {
  CollisionWorld collisionWorld;
  GameSpriteWidgetData widgetData;
  Map<String, Animation> animationMap = {};
  Sprite(this.widgetData, this.collisionWorld);

  double movingSpeed = 50;
  double jumpSpeed = 100;

  Widget build();
  // updateLogic will call first, then it is updateUIIfNeeded

  Rect getCollisionArea();

  void animate(int elapse) {
    Map<String, Animation> removes = {};
    if (animationMap.isNotEmpty) {
      for (var key in animationMap.keys) {
        var anim = animationMap[key];
        anim?.elapse(elapse);
        if (anim != null && anim.isStop()) {
          removes[key] = anim;
        }
      }
      if (removes.isNotEmpty) {
        for (var key in removes.keys) {
          if (removes[key] == animationMap[key]) {
            animationMap.remove(key);
          }
        }
      }
    } else {
      // No animation stuff
      onIdle();
    }
  }

  Rect getCenteredCollisionArea() {
    GameTileData tileData = widgetData.tileData;
    return Rect.fromLTWH(
        widgetData.posX +
            widgetData.widgetWidth *
                (1.0 - tileData.tileActualWidth / tileData.tileWidth) /
                2,
        widgetData.posY +
            widgetData.widgetHeight *
                (1.0 - tileData.tileActualHeight / tileData.tileHeight) /
                2,
        widgetData.widgetWidth * tileData.tileActualWidth / tileData.tileWidth,
        widgetData.widgetHeight *
            tileData.tileActualHeight /
            tileData.tileHeight);
  }

  void movingLeft() {
    double lastOffsetX = 0;
    DoubleAnimation movingAnimation = DoubleAnimation(1000, 0, movingSpeed);
    movingAnimation.onValueChange = (offsetX) {
      widgetData.posX -= (offsetX - lastOffsetX);
      if (collisionWorld.hasCollision(this)) {
        widgetData.posX += (offsetX - lastOffsetX);
        widgetData.update();
        movingAnimation.forceStop();
        return;
      }
      widgetData.update();
      lastOffsetX = offsetX;
    };

    widgetData.tileData.reverseDirection = true;
    AnimationData data =
        widgetData.tileData.getAnimationData(SpriteState.WALKING);
    IntAnimation spriteAnimation =
        data.buildAnimation(1000, widgetData.tileData, () {
      widgetData.update();
    });

    movingAnimation.onStop = () {
      spriteAnimation.forceStop();
    };

    animationMap['moving'] = movingAnimation;
    if (!animationMap.containsKey('sprite')) {
      animationMap['sprite'] = spriteAnimation;
    }
  }

  void movingRight() {
    double lastOffsetX = 0;
    DoubleAnimation movingAnimation = DoubleAnimation(1000, 0, movingSpeed);
    movingAnimation.onValueChange = (offsetX) {
      widgetData.posX += (offsetX - lastOffsetX);
      if (collisionWorld.hasCollision(this)) {
        widgetData.posX -= (offsetX - lastOffsetX);
        widgetData.update();
        movingAnimation.forceStop();
        return;
      }
      widgetData.update();
      lastOffsetX = offsetX;
    };

    widgetData.tileData.reverseDirection = false;
    AnimationData data =
        widgetData.tileData.getAnimationData(SpriteState.WALKING);
    IntAnimation spriteAnimation =
        data.buildAnimation(1000, widgetData.tileData, () {
      widgetData.update();
    });

    movingAnimation.onStop = () {
      spriteAnimation.forceStop();
    };

    animationMap['moving'] = movingAnimation;
    if (!animationMap.containsKey('sprite')) {
      animationMap['sprite'] = spriteAnimation;
    }
  }

  void jumping() {
    AnimationData data = widgetData.tileData.getAnimationData(SpriteState.JUMP);
    IntAnimation jumpGraphicAnimation =
        data.buildAnimation(2000, widgetData.tileData, () {
      widgetData.update();
    });

    DoubleAnimation movingAnimation =
        DoubleAnimation(2000, 0, jumpSpeed * 2 /* 2s */);
    double lastOffsetY = 0;
    movingAnimation.onValueChange = (offsetY) {
      widgetData.posY -= (offsetY - lastOffsetY);
      if (collisionWorld.hasCollision(this)) {
        widgetData.posY += (offsetY - lastOffsetY);
        widgetData.update();
        movingAnimation.forceStop();
        return;
      }
      widgetData.update();
      lastOffsetY = offsetY;
    };
    movingAnimation.onStop = () {
      widgetData.jumpFlag = true;
    };
    animationMap['sprite'] = movingAnimation;
    animationMap['jumping'] = jumpGraphicAnimation;
    if (animationMap.containsKey('moving')) {
      animationMap['moving']?.forceStop();
    }
  }

  void onIdle() {}
}
