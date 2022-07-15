import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';
import 'package:ui/sprite/bulk_sprite_raw_tile.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/sprite_tile.dart';
import 'package:ui/sprite/tile_position.dart';

import 'warrior.dart';
import 'simple_map.dart' as SimpleMap;

class ExampleScene extends Scene {
  late SpriteController _ratController;
  late BulkSpriteController _MapController;

  late Warrior warrior;

  ExampleScene() {
    warrior = Warrior(100, 100, 24, 24);
    addSprite(warrior);
    _ratController = SpriteController(
        tinyWidth: 20, tinyHeight: 20, spriteX: 1.0, spriteY: 0);
    _ratController.posX = 0;
    _ratController.posY = 100;

    _MapController = BulkSpriteController(16, 16, 24, 24);
    _MapController.posX = 180;
    _MapController.posY = 180;
    _MapController.tiles = TilePosition.initMap(
        SimpleMap.positions.toList(), 16, 16, 384, 544, 8, 8);
  }

  @override
  void onKey(GameEventType event) {
    if (event == GameEventType.LEFT) {
      print("press left");
      _ratController.posX += 1;
      _ratController.update();
      IntAnimation animation = IntAnimation(1000, 1, 8);
      animation.onValueChange = (value) {
        if (value == 8) {
          value = 1;
        }
        _ratController.spriteX = value * 1.0;
        _ratController.update();
      };
      if (!animationMap.containsKey('rat')) {
        animationMap['rat'] = animation;
      }
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
        SpriteTile(
          imageSrc: 'images/rats.png',
          controller: _ratController,
        ),
        warrior.build(),
        BulkSpriteTile('images/background_tile.png', _MapController),
        const Text("小嘉嘉快跑~~"),
      ],
    );
  }
}
