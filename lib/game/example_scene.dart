import 'package:flutter/widgets.dart';
import 'package:hab_repo/game/monster.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/tile_position.dart';

import 'simple_map.dart';
import 'warrior.dart';

class ExampleScene extends Scene {
  late SimpleMap map;
  late Warrior warrior;
  late Monster mouse;

  ExampleScene() {
    map = SimpleMap(180, 180, 0, 0, 32, 32);
    warrior = Warrior(100, 100, 24, 24);
    mouse = Monster(0, 100, 20, 20);
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
        map.build(),
        mouse.build(),
        warrior.build(),
        const Text("小嘉嘉快跑~~"),
      ],
    );
  }
}
