import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/sprite.dart';

void main() {
  test('Test collision world', () {
    GameMap map = GameMap([0, 1, 1, 0], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();

    expect(world.testCollision(map, 0, 0, TestSprite(10, 10, 9, 9)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(9, 9, 10, 10)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(11, 10, 9, 9)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(10, 11, 9, 9)), true);

    expect(world.testCollision(map, 1, 0, TestSprite(11, 10, 9, 9)), false);
    expect(world.testCollision(map, 0, 1, TestSprite(10, 11, 9, 9)), false);
  });

  test('Test collision world 2', () {
    GameMap map = GameMap([0, 0, 0, 0, 1, 0, 0, 0, 0], 3, 3, 10, 10);
    CollisionWorld world = CollisionWorld();

    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 9, 29)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 29, 9)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 29, 29)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(5, 5, 20, 20)), true);
  });

  test('Bigger item', () {
    GameMap map = GameMap([0, 0, 0, 1], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();

    expect(world.testCollision(map, 0, 0, TestSprite(1, 1, 10, 10)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(1, 1, 8, 8)), false);
  });
}

class TestSprite extends Sprite {
  TestSprite(posX, posY, widgetWidth, widgetHeight)
      : super(posX * 1.0, posY * 1.0, widgetWidth * 1.0, widgetHeight * 1.0,
            widgetWidth * 1.0, widgetHeight * 1.0);
  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Rect getCollisionArea() {
    return Rect.fromLTWH(posX, posY, widgetWidth, widgetHeight);
  }
}
