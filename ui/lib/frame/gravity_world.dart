import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/frame/game_map.dart';

class GravityWorld {
  late GameMap _map;
  List<Animation> animations = [];
  List<GameSpriteWidgetData> registeredWidgetDatas = [];

  double gravitySpeed = 100;

  void bindGameMap(GameMap map) {
    _map = map;
  }

  void registerListener(GameSpriteWidgetData widgetData) {
    registeredWidgetDatas.add(widgetData);
  }

  void _applyGravity(GameSpriteWidgetData widgetData) {
    double distance = _map.fallingDistance(widgetData);
    if (distance <= 0) return;
    double currentY = widgetData.posY;
    DoubleAnimation animation =
        DoubleAnimation((distance * 1000 / gravitySpeed).ceil(), 0, distance);
    animation.onValueChange = (deltaDistance) {
      widgetData.posY = currentY + deltaDistance;
    };
    animations.add(animation);
  }

  void animate(int elapse) {
    for (GameSpriteWidgetData widgetData in registeredWidgetDatas) {
      if (widgetData.jumpFlag) {
        _applyGravity(widgetData);
        widgetData.jumpFlag = false;
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
