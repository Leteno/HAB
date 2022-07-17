import 'package:flutter/widgets.dart' hide Animation;
import 'package:ui/animation/animation.dart' show Animation;
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/keyboard/game_event.dart';

import '../sprite/sprite.dart';

abstract class Scene {
  List<Sprite> _spriteList = [];
  Map<String, Animation> animationMap = {};

  CollisionWorld collisionWorld = CollisionWorld();

  void addSprite(Sprite sprite) {
    _spriteList.add(sprite);
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
    for (var sprite in _spriteList) {
      sprite.animate(elapse);
    }
  }

  GameMap getGameMap();

  void onKey(GameEventType event);

  // TODO: return Stack with _spriteList.
  Widget build(BuildContext context);
}
