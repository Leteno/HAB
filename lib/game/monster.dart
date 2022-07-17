import 'package:flutter/widgets.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Monster extends Sprite {
  late SpriteController _ratController;
  Monster(super.posX, super.posY, super.widgetWidth, super.widgetHeight,
      super.spriteWidth, super.spriteHeight) {
    _ratController = SpriteController(
        widgetWidth, widgetHeight, spriteWidth, spriteHeight, 1.0, 0);
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

  @override
  Rect getCollisionArea() {
    return Rect.fromLTWH(posX + widgetWidth / 4, posY + widgetHeight / 4,
        widgetWidth / 2, widgetHeight / 2);
  }
}
