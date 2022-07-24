import 'package:flutter_test/flutter_test.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/data/game_tile_data.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/physic/direction.dart';

void main() {
  test('GameMap', () {
    GameMap map = GameMap([0, 1, 0, 1], 2, 2, 0, 0);
    expect(map.isOccupy(0, 0), false);
    expect(map.isOccupy(1, 0), true);
    expect(map.isOccupy(1, 1), true);
  });

  test('nearestBlock', () {
    GameMap map = GameMap([0, 0, 1, 0, 0, 0, 0, 1, 0], 3, 3, 0, 0);
    expect(map.nearestBlock(0, 0, Direction.LEFT), 0);
    expect(map.nearestBlock(0, 0, Direction.RIGHT), 2);
    expect(map.nearestBlock(0, 0, Direction.UP), 0);
    expect(map.nearestBlock(0, 0, Direction.DOWN), 2);

    expect(map.nearestBlock(1, 0, Direction.DOWN), 2);
    expect(map.nearestBlock(1, 0, Direction.RIGHT), 1);
    expect(map.nearestBlock(2, 2, Direction.LEFT), -1);
  });

  test('virtualMapData', () {
    GameMap map0 = GameMap([0, 1, 1, 0], 2, 2, 10, 10);
    expect(map0.virtualMapData, [
      [-1, -1, -1, -1],
      [-1, 0, 1, -1],
      [-1, 1, 0, -1],
      [-1, -1, -1, -1]
    ]);
    GameMap map1 = GameMap([0, 0, 1, 0, 0, 0, 0, 1, 0], 3, 3, 0, 0);
    expect(map1.virtualMapData, [
      [-1, -1, -1, -1, -1],
      [-1, 0, 0, 1, -1],
      [-1, 0, 0, 0, -1],
      [-1, 0, 1, 0, -1],
      [-1, -1, -1, -1, -1]
    ]);
  });

  test('getWonderingRegion', () {
    GameMap map = GameMap([1, 1, 0, 1, 0, 0, 0, 0, 0], 3, 3, 20, 20);

    GameSpriteWidgetData widgetData1 =
        SimpleGameSpriteWidgetData(41, 41, 10, 10);
    WonderingRegion region1 = map.getWonderingRegion(widgetData1);
    expect(region1.leftAtMostOffset, 41);
    expect(region1.rightAtMostOffset, 9);

    GameSpriteWidgetData widgetData2 =
        SimpleGameSpriteWidgetData(41, 21, 10, 10);
    WonderingRegion region2 = map.getWonderingRegion(widgetData2);
    expect(region2.leftAtMostOffset, 21);
    expect(region2.rightAtMostOffset, 9);

    GameSpriteWidgetData widgetData3 =
        SimpleGameSpriteWidgetData(41, 11, 10, 10);
    WonderingRegion region3 = map.getWonderingRegion(widgetData3);
    expect(region3.leftAtMostOffset, 1);
    expect(region3.rightAtMostOffset, 9);
  });
  test('getWonderingRegion-Right', () {
    GameMap map = GameMap([0, 0, 0, 0, 0, 1, 0, 1, 1], 3, 3, 20, 20);

    GameSpriteWidgetData widgetData1 =
        SimpleGameSpriteWidgetData(11, 9, 10, 10);
    WonderingRegion region1 = map.getWonderingRegion(widgetData1);
    expect(region1.leftAtMostOffset, 11);
    expect(region1.rightAtMostOffset, 39);

    GameSpriteWidgetData widgetData2 =
        SimpleGameSpriteWidgetData(11, 11, 10, 10);
    WonderingRegion region2 = map.getWonderingRegion(widgetData2);
    expect(region2.leftAtMostOffset, 11);
    expect(region2.rightAtMostOffset, 19);

    GameSpriteWidgetData widgetData3 =
        SimpleGameSpriteWidgetData(1, 41, 10, 10);
    WonderingRegion region3 = map.getWonderingRegion(widgetData3);
    expect(region3.leftAtMostOffset, 1);
    expect(region3.rightAtMostOffset, 9);
  });
  test('getWonderingRegion-standGround', () {
    GameMap map = GameMap([0, 0, 0, 0, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    GameSpriteWidgetData widgetData1 =
        SimpleGameSpriteWidgetData(21, 21, 10, 10);
    WonderingRegion region1 = map.getWonderingRegion(widgetData1);
    expect(region1.leftAtMostOffset, 21);
    expect(region1.rightAtMostOffset, 29);

    WonderingRegion region2 =
        map.getWonderingRegion(widgetData1, standGround: true);
    expect(region2.leftAtMostOffset, 21);
    expect(region2.rightAtMostOffset, 9);
  });
}

class SimpleGameSpriteWidgetData extends GameSpriteWidgetData {
  SimpleGameSpriteWidgetData(posX, posY, widgetWidth, widgetHeight)
      : super(GameTileData('', 20, 20, 20, 20, 20, 20), posX * 1.0, posY * 1.0,
            widgetWidth * 1.0, widgetHeight * 1.0);
}
