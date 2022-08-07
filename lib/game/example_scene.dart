import 'package:flutter/widgets.dart';
import 'package:hab_repo/game/health_tile.dart';
import 'package:hab_repo/game/monster.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';

import '../data/simple_data.dart';
import 'map01.dart';
import 'warrior.dart';

class ExampleScene extends Scene {
  late Map01 mapSprite;
  late GameMap _map;
  late Warrior warrior;
  late Monster rat;
  late HealthTile healthTile;

  ExampleScene() {
    double gridSize = SimpleData.getInstance().gridSize;
    mapSprite = Map01(0, 0, gridSize, gridSize);
    _map = mapSprite.gameMap();
    collisionWorld.bindGameMap(_map);
    gravityWorld.bindGameMap(_map);
    warrior =
        Warrior(collisionWorld, _map, 0, 0, gridSize / 0.618, gridSize / 0.618);

    rat = Monster(collisionWorld, 80, 180, gridSize / 0.618, gridSize / 0.618);

    addSprite(warrior);
    addSprite(rat);
    gravityWorld.registerListener(warrior);
    gravityWorld.registerListener(rat);
    collisionWorld.addObserver(warrior);
    collisionWorld.addObserver(rat);

    healthTile = HealthTile();
    healthTile.healthController.health = 5;
    healthTile.healthController.currentHealth = 5;
    healthTile.reposition(400, 10);
    healthTile.healthController.update();
    warrior.bindHealthTile(healthTile);

    WonderingRegion region = _map.getWonderingRegion(rat.widgetData);
    print(
        "rat would wonder ${region.leftAtMostOffset} to ${region.rightAtMostOffset}");
    var ratSpeed = 100;
    DoubleAnimation firstGoRight = DoubleAnimation(
        (region.rightAtMostOffset * 1000 / ratSpeed).ceil(),
        0,
        region.rightAtMostOffset);
    var originalX = rat.widgetData.posX;
    firstGoRight.onValueChange = (value) {
      rat.movingRight();
      rat.widgetData.posX = originalX + value;
      rat.widgetData.update();
    };
    var distance = region.rightAtMostOffset + region.leftAtMostOffset;
    DoubleAnimation goLeft =
        DoubleAnimation((distance * 1000 / ratSpeed).ceil(), 0, distance);
    goLeft.onValueChange = (value) {
      rat.movingLeft();
      rat.widgetData.posX = originalX + region.rightAtMostOffset - value;
      rat.widgetData.update();
    };
    DoubleAnimation goRight =
        DoubleAnimation((distance * 1000 / ratSpeed).ceil(), distance, 0);
    goRight.onValueChange = (value) {
      rat.movingRight();
      rat.widgetData.posX = originalX + region.rightAtMostOffset - value;
      rat.widgetData.update();
    };
    firstGoRight.onStop = () {
      goLeft.reset();
      animationMap['rat'] = goLeft;
    };
    goLeft.onStop = () {
      goRight.reset();
      animationMap['rat'] = goRight;
    };
    goRight.onStop = () {
      goLeft.reset();
      animationMap['rat'] = goLeft;
    };
    animationMap['rat'] = firstGoRight;
  }

  @override
  void onKey(GameEventType event) {
    if (event == GameEventType.LEFT) {
      warrior.movingLeft();
    } else if (event == GameEventType.RIGHT) {
      warrior.movingRight();
    } else if (event == GameEventType.UP) {
      warrior.showMask(true);
    } else if (event == GameEventType.DOWN) {
      warrior.showMask(false);
    } else if (event == GameEventType.JUMP) {
      warrior.jumping();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapSprite.build(),
        warrior.build(),
        rat.build(),
        healthTile.build(),
      ],
    );
  }

  @override
  GameMap getGameMap() {
    return _map;
  }
}
