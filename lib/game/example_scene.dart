import 'package:flutter/widgets.dart';
import 'package:hab_repo/game/monster.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/tile_position.dart';

import 'warrior.dart';
import 'simple_map.dart' as SimpleMap;

class ExampleScene extends Scene {
  late BulkSpriteController _MapController;

  late Warrior warrior;
  late Monster mouse;

  ExampleScene() {
    warrior = Warrior(100, 100, 24, 24);
    mouse = Monster(0, 100, 20, 20);
    addSprite(warrior);
    addSprite(mouse);

    _MapController = BulkSpriteController(16, 16, 24, 24);
    _MapController.posX = 180;
    _MapController.posY = 180;
    _MapController.tiles = TilePosition.initMap(
        SimpleMap.positions.toList(), 16, 16, 384, 544, 8, 8);
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
        mouse.build(),
        warrior.build(),
        BulkSpriteTile('images/background_tile.png', _MapController),
        const Text("小嘉嘉快跑~~"),
      ],
    );
  }
}
