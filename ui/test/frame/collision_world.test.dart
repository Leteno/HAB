import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/sprite/sprite.dart';

void main() {
  test('Test collision world', () {
    GameMap map = GameMap([0, 1, 1, 0], 2, 2, 10, 10);
    CollisionWorld world = CollisionWorld();

    expect(world.testCollision(map, 0, 0, TestSprite(10, 10, 10, 10)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(9, 9, 10, 10)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(10, 10, 11, 10)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(10, 10, 10, 11)), true);

    expect(world.testCollision(map, 1, 0, TestSprite(10, 10, 11, 10)), false);
    expect(world.testCollision(map, 0, 1, TestSprite(10, 10, 10, 11)), false);
  });

  test('Test collision world 2', () {
    GameMap map = GameMap([0, 0, 0, 0, 1, 0, 0, 0, 0], 3, 3, 10, 10);
    CollisionWorld world = CollisionWorld(0, 0);

    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 10, 30)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 30, 10)), false);
    expect(world.testCollision(map, 0, 0, TestSprite(0, 0, 30, 30)), true);
    expect(world.testCollision(map, 0, 0, TestSprite(5, 5, 20, 20)), true);
  });
}

class TestSprite extends Sprite {
  TestSprite(super.posX, super.posY, super.width, super.height);

  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
