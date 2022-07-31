import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/sprite/sprite_raw_tile.dart';
import 'package:ui/sprite/sprite_raw_tile.dart';

class SpriteTile extends StatefulWidget {
  GameSpriteWidgetData widgetData;
  SpriteTile({Key? key, required this.widgetData}) : super(key: key);

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpriteTileState extends State<SpriteTile> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    widget.widgetData.bindState(this);
    _updateImage();
  }

  void _updateImage() async {
    ui.Image newImage =
        await getAssetImage(widget.widgetData.tileData.imagePath);
    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Positioned(
          left: widget.widgetData.posX,
          top: widget.widgetData.posY,
          child: Container(
              width: widget.widgetData.widgetWidth,
              height: widget.widgetData.widgetHeight,
              child: SpriteRawTile(
                  image: image!,
                  tileData: widget.widgetData.tileData,
                  maskTileData: widget.widgetData.maskTileData,
                  visible: widget.widgetData.visible)));
    }
    return const Text('Image loading');
  }
}

Future<ui.Image> getAssetImage(String imageSrc) async {
  ByteData data = await rootBundle.load(imageSrc);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}
