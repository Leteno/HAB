import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Warrior extends Sprite {
  late SpriteController _humanController;
  Warrior(super.posX, super.posY, super.widgetWidth, super.widgetHeight,
      super.spriteWidth, super.spriteHeight) {
    _humanController = SpriteController(
        widgetWidth, widgetHeight, spriteWidth, spriteHeight, 1.0, 0);
    _humanController.posX = posX;
    _humanController.posY = posY;
  }

  @override
  Widget build() {
    return SpriteTile(
      imageSrc: 'images/character.png',
      controller: _humanController,
    );
  }

  void moveRight() {
    posX = _humanController.posX += 1;
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

  void jump() {
    DoubleAnimation animation = DoubleAnimation(2000, 0, 100);
    double originalPoxY = _humanController.posY;
    animation.onValueChange = (value) {
      posY = _humanController.posY = originalPoxY - value;
      _humanController.update();
    };
    animation.onStop = () {
      DoubleAnimation animation = DoubleAnimation(2000, 100, 0);
      animation.onValueChange = ((value) {
        posY = _humanController.posY = originalPoxY - value;
        _humanController.update();
      });
      animationMap['human'] = animation;
    };
    animationMap['human'] = animation;
  }

  @override
  Rect getCollisionArea() {
    return Rect.fromLTWH(posX + widgetWidth / 4, posY + widgetHeight / 4,
        widgetWidth / 2, widgetHeight / 2);
  }
}
