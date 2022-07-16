import 'package:ui/frame/collision_world.dart';
import 'package:ui/physic/math.dart';
import 'package:ui/sprite/sprite.dart';

class GameMap {
  List<int> mapData;
  int rowCount;
  int columnCount;
  double gridSizeX;
  double gridSizeY;
  GameMap(this.mapData, this.columnCount, this.rowCount, this.gridSizeX,
      this.gridSizeY);

  bool isOccupy(int x, int y) {
    assert(Math.between(0, columnCount - 1, x));
    assert(Math.between(0, rowCount - 1, y));

    return mapData[x + y * columnCount] > 0;
  }
}
