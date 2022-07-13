import 'package:ui/physic/math.dart';

class GameMap {
  List<int> mapData;
  int rowCount;
  int columnCount;
  GameMap(this.mapData, this.columnCount, this.rowCount);

  bool isOccupy(int x, int y) {
    assert(Math.between(0, columnCount - 1, x));
    assert(Math.between(0, rowCount - 1, y));

    return mapData[x + y * columnCount] > 0;
  }
}
