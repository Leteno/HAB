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

  double movingSpeed = 20;
  double distancePerMove = 10;
  double jumpSpeed = 100;
  double distancePerJump = 200;

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
    Animation? previousMovingLeft = animationMap['movingLeft'];

    double lastOffsetX = 0;
    int duration = (distancePerMove / movingSpeed * 1000).ceil();

    if (previousMovingLeft != null) {
      if (previousMovingLeft.duration > duration / 3) {
        // We only deal with the left press event in very last moment.
        return;
      }
    }

    DoubleAnimation movingAnimation =
        DoubleAnimation(duration, 0, distancePerMove);
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
        data.buildAnimation(duration, widgetData.tileData, () {
      widgetData.update();
    });

    if (previousMovingLeft != null) {
      previousMovingLeft.next(movingAnimation);
    } else {
      animationMap['movingLeft'] = movingAnimation;
    }
    if (!animationMap.containsKey('jumping') ||
        !animationMap.containsKey('failling')) {
      if (previousMovingLeft != null) {
        animationMap['sprite']?.next(spriteAnimation);
      } else {
        animationMap['sprite'] = spriteAnimation;
      }
    }
  }

  void movingRight() {
    Animation? previousMovingRight = animationMap['movingRight'];

    double lastOffsetX = 0;
    int duration = (distancePerMove / movingSpeed * 1000).ceil();

    if (previousMovingRight != null) {
      if (previousMovingRight.duration > duration / 3) {
        // We only deal with the left press event in very last moment.
        return;
      }
    }

    DoubleAnimation movingAnimation =
        DoubleAnimation(duration, 0, distancePerMove);
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
        data.buildAnimation(duration, widgetData.tileData, () {
      widgetData.update();
    });

    // movingAnimation.onStop = () {
    //   spriteAnimation.forceStop();
    // };

    if (previousMovingRight != null) {
      previousMovingRight.next(movingAnimation);
    } else {
      animationMap['movingRight'] = movingAnimation;
    }
    if (!animationMap.containsKey('jumping') ||
        !animationMap.containsKey('failling')) {
      if (previousMovingRight != null) {
        animationMap['sprite']?.next(spriteAnimation);
      } else {
        animationMap['sprite'] = spriteAnimation;
      }
    }
  }

  void jumping() {
    if (animationMap.containsKey('failling')) {
      return;
    }

    int duration = (distancePerJump / jumpSpeed * 1000).ceil();
    AnimationData data = widgetData.tileData.getAnimationData(SpriteState.JUMP);
    IntAnimation jumpGraphicAnimation =
        data.buildAnimation(duration, widgetData.tileData, () {
      widgetData.update();
    });

    DoubleAnimation movingAnimation =
        DoubleAnimation(duration, 0, distancePerJump);
    double lastOffsetY = 0;
    movingAnimation.onValueChange = (offsetY) {
      widgetData.posY -= (offsetY - lastOffsetY);
      if (collisionWorld.hasCollision(this)) {
        widgetData.posY += (offsetY - lastOffsetY);
        widgetData.update();
        movingAnimation.forceStop();
        jumpGraphicAnimation.forceStop();
        return;
      }
      widgetData.update();
      lastOffsetY = offsetY;
    };
    movingAnimation.onStop = () {
      widgetData.jumpFlag = true;
    };
    animationMap['jumping'] = movingAnimation;
    animationMap['sprite'] = jumpGraphicAnimation;
  }

  void onIdle() {}
}
