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

  test('getWonderingRegion-perciseOnSurface', () {
    GameMap map = GameMap([0, 0, 0, 0, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    GameSpriteWidgetData widgetData1 =
        SimpleGameSpriteWidgetData(30, 30, 10, 10);
    WonderingRegion region1 = map.getWonderingRegion(widgetData1);
    expect(region1.leftAtMostOffset, 30);
    expect(region1.rightAtMostOffset, 20);

    GameSpriteWidgetData widgetData2 =
        SimpleGameSpriteWidgetData(30, 30, 10, 10);
    WonderingRegion region2 =
        map.getWonderingRegion(widgetData2, standGround: true);
    expect(region2.leftAtMostOffset, 30);
    expect(region2.rightAtMostOffset, 0);
  });

  test('fallingDistance', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    GameSpriteWidgetData widgetData1 = SimpleGameSpriteWidgetData(0, 0, 10, 10);
    expect(map.fallingDistance(widgetData1), 10);

    GameSpriteWidgetData widgetData2 =
        SimpleGameSpriteWidgetData(30, 0, 10, 10);
    expect(map.fallingDistance(widgetData2), 30);

    GameSpriteWidgetData widgetData3 =
        SimpleGameSpriteWidgetData(50, 0, 10, 10);
    expect(map.fallingDistance(widgetData3), 50);

    GameSpriteWidgetData widgetData4 =
        SimpleGameSpriteWidgetData(21, 11, 10, 10);
    expect(map.fallingDistance(widgetData4), 19);
  });

  test('hasCollision', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);

    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 10, 10)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(1, 0, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 1, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 20, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(21, 20, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 21, 20, 20)), true);
  });

  test('hasCollision - with GameGridTypeFunction return EMPTY', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);
    // All the grid are not block, even value 1;
    map.getBlockTypeFunc = (blockValue) => GameGridType.EMPTY;

    // We expect no collision in this map.
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 10, 10)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(1, 0, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 1, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 20, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(21, 20, 20, 20)), false);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 21, 20, 20)), false);
  });

  test('hasCollision - with GameGridTypeFunction return BLOCK', () {
    GameMap map = GameMap([0, 0, 0, 1, 0, 0, 1, 1, 0], 3, 3, 20, 20);
    // All the grid are block, even value 0;
    map.getBlockTypeFunc = (blockValue) => GameGridType.BLOCK;

    // We expect no collision in this map.
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 10, 10)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 0, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(1, 0, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(0, 1, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 20, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(21, 20, 20, 20)), true);
    expect(map.hasCollision(SimpleGameSpriteWidgetData(20, 21, 20, 20)), true);
  });

  test('getCollisionType', () {
    GameMap map = GameMap([0, 2, 0, 1, 3, 0, 1, 1, 0], 3, 3, 20, 20);
    map.getBlockTypeFunc = (blockValue) {
      switch (blockValue) {
        case 0:
          return GameGridType.EMPTY;
        case 2:
          return GameGridType.BUSH;
        case 1:
        default:
          return GameGridType.BLOCK;
      }
    };

    expect(map.getCollisionType(SimpleGameSpriteWidgetData(0, 0, 10, 10)),
        [GameGridType.EMPTY]);
    expect(map.getCollisionType(SimpleGameSpriteWidgetData(20, 10, 20, 20)),
        [GameGridType.BUSH, GameGridType.BLOCK]);
    expect(map.getCollisionType(SimpleGameSpriteWidgetData(10, 10, 20, 20)),
        [GameGridType.EMPTY, GameGridType.BUSH, GameGridType.BLOCK]);
    expect(map.getCollisionType(SimpleGameSpriteWidgetData(30, 10, 20, 10)),
        [GameGridType.BUSH, GameGridType.EMPTY]);
  });
}

class SimpleGameSpriteWidgetData extends GameSpriteWidgetData {
  SimpleGameSpriteWidgetData(posX, posY, widgetWidth, widgetHeight)
      : super(GameTileData('', 20, 20, 20, 20, 20, 20), posX * 1.0, posY * 1.0,
            widgetWidth * 1.0, widgetHeight * 1.0) {
    AnimationData failAnimation = AnimationData();
    failAnimation.animationIndexes.add(SpriteIndex(3, 2));
    tileData.state2Animation[SpriteState.FAILING] = failAnimation;
  }
}
