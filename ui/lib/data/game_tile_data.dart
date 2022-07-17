/*
 * This is a DAO, store the data related to tile painting, such as
 * * tile image name
 * * tile size
 * * tile actual size (In png, some area are transparent, and for collision detection, we may need to know the actual size.)
 */
class GameTileData {
  final String imagePath;
  final double tileWidth;
  final double tileHeight;
  final double tileActualWidth;
  final double tileActualHeight;

  final double imageWidth;
  final double imageHeight;
  double imageSpriteStartPoxX = 0;
  double imageSpriteStartPoxY = 0;
  int imageSpriteIndexX = 1;
  int imageSpriteIndexY = 0;

  GameTileData(
      this.imagePath,
      this.tileWidth,
      this.tileHeight,
      this.tileActualWidth,
      this.tileActualHeight,
      this.imageWidth,
      this.imageHeight);
}
