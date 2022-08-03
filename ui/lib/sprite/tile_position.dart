class TilePosition {
  int srcX;
  int srcY;
  int dstX;
  int dstY;
  TilePosition(this.srcX, this.srcY, this.dstX, this.dstY);

  // tileSizeX: count of tiles in one row
  // tileSizeY: count of tiles in one column
  static List<TilePosition> initMap(
      List<int> positions,
      int tileWidth,
      int tileHeight,
      int imageWidth,
      int imageHeight,
      int tileSizeX,
      int tileSizeY) {
    assert(tileSizeX * tileSizeY == positions.length);
    List<TilePosition> result = [];
    int tilePerRow = (imageWidth / tileWidth).floor();

    for (int y = 0; y < tileSizeY; y++) {
      for (int x = 0; x < tileSizeX; x++) {
        int posInfo = positions[y * tileSizeX + x];
        if (posInfo > 0) {
          // Map data contains 0
          // But map tile starts from 1.
          // So here we minus 1, to align with index 0
          posInfo -= 1;
          int srcX = posInfo % tilePerRow;
          int srcY = (posInfo / tilePerRow).floor();
          result.add(TilePosition(srcX, srcY, x, y));
        }
      }
    }
    return result;
  }
}
