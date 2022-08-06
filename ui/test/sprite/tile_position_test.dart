import 'package:flutter_test/flutter_test.dart';
import 'package:ui/sprite/tile_position.dart';

void main() {
  test('empty tile position', () {
    List<int> positions = [];
    List<TilePosition> result =
        TilePosition.initMap(positions, 20, 20, 100, 100, 0, 0);
    expect(result.isEmpty, true);
  });
  test('simple tile position', () {
    List<int> positions = [12, 0, 1, 17];
    List<TilePosition> result =
        TilePosition.initMap(positions, 20, 20, 100, 100, 2, 2);
    expect(result.isEmpty, false);
    expect(result.length, 3);
    expect(result[0], TilePositionMatcher(TilePosition(1, 2, 0, 0)));
    expect(result[1], TilePositionMatcher(TilePosition(0, 0, 0, 1)));
    expect(result[2], TilePositionMatcher(TilePosition(1, 3, 1, 1)));
  });
}

class TilePositionMatcher extends Matcher {
  TilePosition expectPos;
  TilePositionMatcher(this.expectPos);

  @override
  Description describe(Description description) {
    return StringDescription('TilePosition Matcher');
  }

  @override
  bool matches(item, Map matchState) {
    TilePosition actual = item as TilePosition;
    if (actual.srcX != expectPos.srcX ||
        actual.srcY != expectPos.srcY ||
        actual.dstX != expectPos.dstX ||
        actual.dstY != expectPos.dstY) {
      print(
          'TilePostion is not same: actual: (${actual.srcX}, ${actual.srcY}, ${actual.dstX}, ${actual.dstY}), expect (${expectPos.srcX}, ${expectPos.srcY}, ${expectPos.dstX}, ${expectPos.dstY})');
      return false;
    }
    return true;
  }
}
