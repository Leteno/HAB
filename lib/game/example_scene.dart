import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/sprite/sprite_tile.dart';

class ExampleScene extends Scene {
  late SpriteController _humanController;
  late SpriteController _ratController;

  ExampleScene() {
    _humanController = SpriteController(
        tinyWidth: 24, tinyHeight: 24, spriteX: 1.0, spriteY: 0);
    _humanController.posX = 100;
    _humanController.posY = 100;
    _ratController = SpriteController(
        tinyWidth: 20, tinyHeight: 20, spriteX: 1.0, spriteY: 0);
    _ratController.posX = 0;
    _ratController.posY = 100;
  }

  @override
  void onKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
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
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      print("press right");
      _humanController.posX += 1;
      _humanController.update();
      IntAnimation animation = IntAnimation(1000, 1, 6);
      animation.onValueChange = (value) {
        if (value == 6) {
          value = 1;
        }
        _humanController.spriteX = value * 1.0;
        _humanController.update();
      };
      if (!animationMap.containsKey('human')) {
        animationMap['human'] = animation;
      }
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
        SpriteTile(
          imageSrc: 'images/character.png',
          controller: _humanController,
        ),
        const Text("小嘉嘉快跑~~"),
      ],
    );
  }
}
