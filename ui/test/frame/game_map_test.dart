import 'package:flutter_test/flutter_test.dart';
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
    expect(map.nearestBlock(0, 0, Direction.DOWN), 0);

    expect(map.nearestBlock(1, 0, Direction.DOWN), 2);
    expect(map.nearestBlock(1, 0, Direction.RIGHT), 1);
    expect(map.nearestBlock(2, 2, Direction.LEFT), -1);
  });
}
