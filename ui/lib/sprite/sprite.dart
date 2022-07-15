import 'package:flutter/widgets.dart' hide Animation;
import 'package:ui/animation/animation.dart' show Animation;

abstract class Sprite {
  double posX;
  double posY;
  double width;
  double height;
  Map<String, Animation> animationMap = {};
  Sprite(this.posX, this.posY, this.width, this.height);

  Widget build();
  // updateLogic will call first, then it is updateUIIfNeeded

  Rect getRect() {
    return Rect.fromLTWH(posX, posY, width, height);
  }

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
