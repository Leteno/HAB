import 'package:flutter/widgets.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Monster extends Sprite {
  late SpriteController _ratController;
  Monster(super.posX, super.posY, super.width, super.height) {
    _ratController = SpriteController(
        tinyWidth: 20, tinyHeight: 20, spriteX: 1.0, spriteY: 0);
    _ratController.posX = posX;
    _ratController.posY = posY;
  }

  void moveRight() {
    posX = _ratController.posX += 1;
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
  }

  @override
  Widget build() {
    return SpriteTile(
      imageSrc: 'images/rats.png',
      controller: _ratController,
    );
  }
}
