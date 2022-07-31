import 'package:flutter/widgets.dart';
import 'package:hab_repo/game/monster.dart';
import 'package:ui/animation/animation.dart';
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
    gravityWorld.bindGameMap(_map);
    warrior = Warrior(collisionWorld, 80, 480, 80, 80);
    addSprite(warrior);
    gravityWorld.registerListener(warrior);

    rat = Monster(collisionWorld, 80, 180, 80, 80);
    addSprite(rat);
    gravityWorld.registerListener(rat);

    collisionWorld.addObserver(warrior);
    collisionWorld.addObserver(rat);

    WonderingRegion region =
        _map.getWonderingRegion(rat.widgetData, standGround: true);
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
