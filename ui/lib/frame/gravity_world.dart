import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/physic/math.dart';
import 'package:ui/sprite/sprite.dart';

import '../data/game_tile_data.dart';

class GravityWorld {
  late GameMap _map;
  List<Animation> animations = [];
  List<Sprite> registereSprites = [];

  double gravitySpeed = 100;

  void bindGameMap(GameMap map) {
    _map = map;
  }

  void registerListener(Sprite sprite) {
    registereSprites.add(sprite);
  }

  void _applyGravity(Sprite sprite) {
    GameSpriteWidgetData widgetData = sprite.widgetData;
    double distance = _map.fallingDistance(widgetData);
    if (Math.isSameInMath(distance, 0)) return;
    double currentY = widgetData.posY;
    int duration = (distance * 1000 / gravitySpeed).ceil();
    DoubleAnimation animation = DoubleAnimation(duration, 0, distance);
    animation.onValueChange = (deltaDistance) {
      widgetData.posY = currentY + deltaDistance;
    };
    AnimationData data =
        widgetData.tileData.getAnimationData(SpriteState.FAILING);
    IntAnimation spriteAnimation =
        data.buildAnimation(duration, widgetData.tileData, () {
      widgetData.update();
    });
    sprite.animationMap['failling'] = animation;
    sprite.animationMap['sprite'] = spriteAnimation;
  }

  void animate(int elapse) {
    for (Sprite sprite in registereSprites) {
      GameSpriteWidgetData widgetData = sprite.widgetData;
      if (!widgetData.jumpFlag) {
        _applyGravity(sprite);
      }
    }
    List<Animation> newAnimations = [];
    for (Animation animation in animations) {
      animation.elapse(elapse);
      if (!animation.isStop()) {
        newAnimations.add(animation);
      }
    }
    animations.clear();
    animations = newAnimations;
  }
}
