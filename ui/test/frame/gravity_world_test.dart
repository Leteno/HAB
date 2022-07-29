import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/frame/collision_world.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/frame/gravity_world.dart';
import 'package:ui/sprite/sprite.dart';

import 'game_map_test.dart';

void main() {
  test('test gravity world - register listener', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    GravityWorld gravityWorld = GravityWorld();
    gravityWorld.bindGameMap(map);

    GameSpriteWidgetData widgetData = SimpleGameSpriteWidgetData(0, 0, 10, 10);
    widgetData.fakeStateForTest();
    Sprite sprite = TestSprite(widgetData);
    gravityWorld.registerListener(sprite);

    // double offsetPerMillisecond = gravityWorld.gravitySpeed / 1000;
    // gravitySpeed is 100 now, so the offsetPerMillisecond is 0.1

    // make a kick
    gravityWorld.animate(10);

    sprite.animate(10);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 1);

    sprite.animate(40);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 5);

    // 10 is the largest distance current object could fail.
    sprite.animate(1000);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 10);
  });
}

class TestSprite extends Sprite {
  TestSprite(GameSpriteWidgetData widgetData)
      : super(widgetData, CollisionWorld()) {}

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
