import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/sprite.dart';

void main() {
  test('Test collision world', () {
    GameMap map = GameMap([0, 1, 1, 0], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    expect(world.testCollision(TestSprite(10, 10, 9, 9)), false);
    expect(world.testCollision(TestSprite(9, 9, 10, 10)), true);
    expect(world.testCollision(TestSprite(11, 10, 9, 9)), true);
    expect(world.testCollision(TestSprite(10, 11, 9, 9)), true);

    world.extraOffsetLeft = 1;
    world.extraOffsetTop = 0;
    expect(world.testCollision(TestSprite(11, 10, 9, 9)), false);
    world.extraOffsetLeft = 0;
    world.extraOffsetTop = 1;
    expect(world.testCollision(TestSprite(10, 11, 9, 9)), false);
  });

  test('Test collision world 2', () {
    GameMap map = GameMap([0, 0, 0, 0, 1, 0, 0, 0, 0], 3, 3, 10, 10);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    expect(world.testCollision(TestSprite(0, 0, 9, 29)), false);
    expect(world.testCollision(TestSprite(0, 0, 29, 9)), false);
    expect(world.testCollision(TestSprite(0, 0, 29, 29)), true);
    expect(world.testCollision(TestSprite(5, 5, 20, 20)), true);
  });

  test('Bigger item', () {
    GameMap map = GameMap([0, 0, 0, 1], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    expect(world.testCollision(TestSprite(1, 1, 10, 10)), true);
    expect(world.testCollision(TestSprite(1, 1, 8, 8)), false);
  });

  test('Collision Detection', () {
    GameMap map = GameMap([0, 0, 0, 1], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    CollisionResult result =
        world.detectCollision(TestSprite(0, 0, 9, 9), Offset.zero);
    expect(result.isCollision, false);

    result =
        world.detectCollision(TestSprite(10, 0, 8, 8), const Offset(0, 10));
    expect(result.isCollision, true);
    expect(result.correction.dx, 0);
    expect(result.correction.dy, -8);

    result =
        world.detectCollision(TestSprite(0, 0, 8, 8), const Offset(15, 16));
    expect(result.isCollision, true);
    expect(result.correction.dx, -13);
    expect(result.correction.dy, -14);
  });
}

class TestSprite extends Sprite {
  TestSprite(posX, posY, widgetWidth, widgetHeight)
      : super(
            GameSpriteWidgetData(GameTileData('', 1, 1, 1, 1, 1, 1), posX * 1.0,
                posY * 1.0, widgetWidth * 1.0, widgetHeight * 1.0),
            CollisionWorld());
  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Rect getCollisionArea() {
    return Rect.fromLTWH(widgetData.posX, widgetData.posY,
        widgetData.widgetWidth, widgetData.widgetHeight);
  }
}
