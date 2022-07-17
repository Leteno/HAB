import 'package:flutter/widgets.dart' hide Animation;
import 'package:ui/animation/animation.dart' show Animation;

abstract class Sprite {
  double posX;
  double posY;
  // Size when draw sprite, include white space region.
  double widgetWidth;
  double widgetHeight;
  double spriteWidth;
  double spriteHeight;
  Map<String, Animation> animationMap = {};
  Sprite(
    this.posX,
    this.posY,
    this.widgetWidth,
    this.widgetHeight,
    this.spriteWidth,
    this.spriteHeight,
  );

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
    }
  }
}
