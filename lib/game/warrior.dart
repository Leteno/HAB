import 'dart:math';
import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:hab_repo/data/warrior_mask_tile_data.dart';
import 'package:hab_repo/data/warrior_tile_data.dart';
import 'package:hab_repo/game/health_tile.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/sprite.dart';
import 'package:ui/sprite/sprite_tile.dart';

class Warrior extends Sprite {
  GameMap gameMap;
  HealthTile? _healthTile;
  Warrior(collisionWorld, this.gameMap, posX, posY, widgetWidth, widgetHeight)
      : super(
            GameSpriteWidgetData(WarriorTileData(), posX * 1.0, posY * 1.0,
                widgetWidth * 1.0, widgetHeight * 1.0),
            collisionWorld) {
    movingSpeed = 50;
    widgetData.maskTileData = WarriorMaskTileData();
    widgetData.maskTileData?.loadImage(() {
      widgetData.update();
    });
  }

  @override
  Widget build() {
    return SpriteTile(
      widgetData: widgetData,
    );
  }

  @override
  Rect getCollisionArea() {
    return getCenteredCollisionArea();
  }

  @override
  void onIdle() {
    AnimationData data = widgetData.tileData.getAnimationData(SpriteState.IDLE);
    IntAnimation animation = data.buildAnimation(800, widgetData.tileData, () {
      widgetData.update();
    });
    animationMap['idle'] = animation;
  }

  @override
  void onCollissionWith(Sprite sprite) {
    onGetHurt(1);
  }

  void setBlink() {
    if (widgetData.maskTileData != null && widgetData.maskTileData!.shown) {
      return;
    }
    IntAnimation animation = IntAnimation(3000, 1, 10);
    bool visible = false;
    int lastNumber = 0;
    animation.onValueChange = (value) {
      if (lastNumber == value) return;
      lastNumber = value;
      widgetData.visible = visible;
      visible = !visible;
      widgetData.update();
    };
    animation.onStop = () {
      widgetData.visible = true;
    };
    animationMap['blink'] = animation;
  }

  void showMask(bool show) {
    List<GameGridType> types = gameMap.getCollisionType(widgetData);
    if (!types.contains(GameGridType.BUSH)) return;
    widgetData.maskTileData!.shown = show;
    widgetData.update();
  }

  @override
  void animate(int elapse) {
    super.animate(elapse);
    List<GameGridType> types =
        gameMap.getCollisionType(widgetData, touchIncluded: true);
    if (!types.contains(GameGridType.BUSH)) {
      if (widgetData.maskTileData!.shown) {
        widgetData.maskTileData!.shown = false;
        widgetData.update();
      }
    }
    if (types.contains(GameGridType.FIRE)) {
      onGetHurt(3);
    }
  }

  void onGetHurt(int damage) {
    // When warrior is blink, he/she is invincible.
    if (animationMap.containsKey('blink')) {
      return;
    }
    setBlink();
    if (_healthTile != null) {
      _healthTile!.healthController.currentHealth =
          max(_healthTile!.healthController.currentHealth - damage, 0);
      _healthTile!.healthController.update();
    }
  }

  void bindHealthTile(HealthTile tile) {
    _healthTile = tile;
  }
}
