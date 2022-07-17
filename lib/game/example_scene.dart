import 'package:flutter/widgets.dart';
import 'package:hab_repo/game/monster.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';

import 'simple_map.dart';
import 'warrior.dart';

class ExampleScene extends Scene {
  late SimpleMap mapSprite;
  late GameMap _map;
  late Warrior warrior;
  late Monster mouse;

  ExampleScene() {
    mapSprite = SimpleMap(0, 0, 0, 0, 0, 0, 32, 32);
    _map = mapSprite.gameMap();
    warrior = Warrior(20, 120, 80, 80, 24, 24);
    mouse = Monster(80, 120, 80, 80, 20, 20);
    addSprite(warrior);
    addSprite(mouse);
  }

  @override
  void onKey(GameEventType event) {
    if (event == GameEventType.LEFT) {
      mouse.moveRight();
    } else if (event == GameEventType.RIGHT) {
      warrior.moveRight();
    } else if (event == GameEventType.JUMP) {
      warrior.jump();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapSprite.build(),
        mouse.build(),
        warrior.build(),
      ],
    );
  }

  @override
  GameMap getGameMap() {
    return _map;
  }
}
