import 'package:ui/frame/collision_world.dart';
import 'package:ui/physic/direction.dart';
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

  // Return the distance to nearest block.
  // return 0 if not exists.
  int nearestBlock(int x, int y, Direction direction) {
    assert(Math.between(0, columnCount - 1, x));
    assert(Math.between(0, rowCount - 1, y));

    if (direction == Direction.LEFT) {
      for (int i = x - 1; i >= 0; i--) {
        if (mapData[i + y * columnCount] > 0) {
          return i - x;
        }
      }
    } else if (direction == Direction.RIGHT) {
      for (int i = x + 1; i < columnCount; i++) {
        if (mapData[i + y * columnCount] > 0) {
          return i - x;
        }
      }
    } else if (direction == Direction.UP) {
      for (int i = y - 1; i >= 0; i--) {
        if (mapData[x + i * columnCount] > 0) {
          return i - y;
        }
      }
    } else if (direction == Direction.DOWN) {
      for (int i = y + 1; i < rowCount; i++) {
        if (mapData[x + i * columnCount] > 0) {
          return i - y;
        }
      }
    }
    return 0;
  }
}
