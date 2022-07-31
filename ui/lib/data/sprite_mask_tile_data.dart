import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:ui/data/game_tile_data.dart';

typedef OnLoadFinishFunc = void Function();

class SpriteMaskTileData {
  bool shown = false;
  GameTileData tileData;
  ui.Image? image;

  // We want a mask hover over the sprite or something.
  // Here, as the sprite actual size is different from its posX, posY
  // And we need to make the adjustment to make sure the mask hover
  // in the right position. So we need additionalOffset.
  // Will be used when painting on canvas
  double additionalOffsetX;
  double additionalOffsetY;

  SpriteMaskTileData(
      this.tileData, this.additionalOffsetX, this.additionalOffsetY);

  void loadImage(OnLoadFinishFunc? func) async {
    image = await getAssetImage(tileData.imagePath);
    func?.call();
  }
}

Future<ui.Image> getAssetImage(String imageSrc) async {
  ByteData data = await rootBundle.load(imageSrc);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}
