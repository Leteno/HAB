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

  test('Collision Observer Detection Few objects', () {
    GameMap map = GameMap([0, 0, 0, 0, 0, 0, 0, 0, 0], 3, 3, 20, 20);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    TestSprite mouse = TestSprite(0, 0, 20, 20);
    TestSprite cat = TestSprite(25, 25, 30, 30);
    world.addObserver(mouse);
    world.addObserver(cat);

    world.detectCollisionForObservers();

    expect(mouse.collisionSprite, null);
    expect(cat.collisionSprite, null);

    mouse.widgetData.posX = 10;
    mouse.widgetData.posY = 10;
    world.detectCollisionForObservers();
    expect(mouse.collisionSprite, cat);
    expect(cat.collisionSprite, mouse);
  });

  test('Collision Observer Detection Many objects', () {
    GameMap map = GameMap([0, 0, 0, 0, 0, 0, 0, 0, 0], 3, 3, 20, 20);
    CollisionWorld world = CollisionWorld();
    world.bindGameMap(map);

    TestSprite mouse = TestSprite(0, 0, 20, 20);
    TestSprite cat = TestSprite(25, 25, 30, 30);
    TestSprite nobody1 = TestSprite(0, 30, 1, 1);
    TestSprite nobody2 = TestSprite(1, 30, 1, 1);
    TestSprite nobody3 = TestSprite(2, 30, 1, 1);
    TestSprite nobody4 = TestSprite(3, 30, 1, 1);
    world.addObserver(mouse);
    world.addObserver(cat);
    world.addObserver(nobody1);
    world.addObserver(nobody2);
    world.addObserver(nobody3);
    world.addObserver(nobody4);

    world.detectCollisionForObservers();

    expect(mouse.collisionSprite, null);
    expect(cat.collisionSprite, null);
    expect(nobody1.collisionSprite, null);
    expect(nobody2.collisionSprite, null);
    expect(nobody3.collisionSprite, null);
    expect(nobody4.collisionSprite, null);

    mouse.widgetData.posX = 10;
    mouse.widgetData.posY = 10;
    world.detectCollisionForObservers();
    expect(mouse.collisionSprite, cat);
    expect(cat.collisionSprite, mouse);
    expect(nobody1.collisionSprite, null);
    expect(nobody2.collisionSprite, null);
    expect(nobody3.collisionSprite, null);
    expect(nobody4.collisionSprite, null);
  });
}

class TestSprite extends Sprite {
  TestSprite(posX, posY, widgetWidth, widgetHeight)
      : super(
            GameSpriteWidgetData(GameTileData('', 1, 1, 1, 1, 1, 1), posX * 1.0,
                posY * 1.0, widgetWidth * 1.0, widgetHeight * 1.0),
            CollisionWorld());
  Sprite? collisionSprite = null;
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

  void onCollissionWith(Sprite sprite) {
    collisionSprite = sprite;
  }
}
