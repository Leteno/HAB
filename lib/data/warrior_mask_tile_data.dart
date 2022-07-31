import 'package:ui/data/game_tile_data.dart';
import 'package:ui/data/sprite_mask_tile_data.dart';

class WarriorMaskTileData extends SpriteMaskTileData {
  WarriorMaskTileData()
      : super(
            GameTileData(
                'images/background_tile.png', 16, 16, 10, 10, 384, 544),
            14,
            14) {
    int tilePerRow = (tileData.imageWidth / tileData.tileWidth).floor();
    tileData.imageSpriteIndexX = 468 % tilePerRow;
    tileData.imageSpriteIndexY = (468 / tilePerRow).floor();
  }
}
