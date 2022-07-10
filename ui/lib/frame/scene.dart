import 'package:flutter/widgets.dart' hide Animation;
import 'package:ui/animation/animation.dart' show Animation;
import 'package:ui/keyboard/game_event.dart';

abstract class Scene {
  Map<String, Animation> animationMap = {};

  void animate(int elapse) {
    List<String> removeKeys = [];
    if (animationMap.isNotEmpty) {
      for (var key in animationMap.keys) {
        var anim = animationMap[key];
        anim?.elapse(elapse);
        if (anim == null || anim.isStop()) {
          removeKeys.add(key);
        }
      }
      for (var key in removeKeys) {
        animationMap.remove(key);
      }
    }
  }

  void onKey(GameEventType event);

  Widget build(BuildContext context);
}
