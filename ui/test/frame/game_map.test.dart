import 'package:flutter_test/flutter_test.dart';
import 'package:ui/frame/game_map.dart';

void main() {
  test('GameMap', () {
    GameMap map = GameMap([0, 1, 0, 1], 2, 2);
    expect(map.isOccupy(0, 0), false);
    expect(map.isOccupy(1, 0), true);
    expect(map.isOccupy(1, 1), true);
  });
}
