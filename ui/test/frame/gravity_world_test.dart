import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/frame/gravity_world.dart';

import 'game_map_test.dart';

void main() {
  test('test gravity world - register listener', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    GravityWorld gravityWorld = GravityWorld();
    gravityWorld.bindGameMap(map);

    GameSpriteWidgetData widgetData = SimpleGameSpriteWidgetData(0, 0, 10, 10);
    gravityWorld.registerListener(widgetData);

    // double offsetPerMillisecond = gravityWorld.gravitySpeed / 1000;
    // gravitySpeed is 100 now, so the offsetPerMillisecond is 0.1
    gravityWorld.animate(10);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 1);

    gravityWorld.animate(40);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 5);

    // 10 is the largest distance current object could fail.
    gravityWorld.animate(1000);
    expect(widgetData.posX, 0);
    expect(widgetData.posY, 10);
  });
}
