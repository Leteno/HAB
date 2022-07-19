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
  late Monster rat;

  ExampleScene() {
    mapSprite = SimpleMap(0, 0, 0, 0, 80, 80);
    _map = mapSprite.gameMap();
    collisionWorld.bindGameMap(_map);
    warrior = Warrior(collisionWorld, 80, 480, 80, 80);
    addSprite(warrior);

    rat = Monster(100, 180, 80, 80);
    addSprite(rat);
  }

  @override
  void onKey(GameEventType event) {
    if (event == GameEventType.LEFT) {
      warrior.moveLeft();
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
        rat.build(),
        warrior.build(),
      ],
    );
  }

  @override
  GameMap getGameMap() {
    return _map;
  }
}
