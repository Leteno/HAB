import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ui/data/game_sprite_data.dart';
import 'package:ui/sprite/sprite_raw_tile.dart';
import 'package:ui/sprite/sprite_raw_tileB.dart';

class SpriteTileB extends StatefulWidget {
  String imageSrc;
  GameSpriteWidgetData widgetData;
  SpriteTileB({Key? key, required this.imageSrc, required this.widgetData})
      : super(key: key);

  @override
  State<SpriteTileB> createState() => _SpriteTileStateB();
}

class _SpriteTileStateB extends State<SpriteTileB> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    widget.widgetData.bindState(this);
    _updateImage();
  }

  void _updateImage() async {
    ui.Image newImage = await getAssetImage(widget.imageSrc);
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
              child: SpriteRawTileB(
                  image: image!, tileData: widget.widgetData.tileData)));
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
