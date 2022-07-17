import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ui/sprite/sprite_raw_tile.dart';

class SpriteTile extends StatefulWidget {
  String imageSrc;
  SpriteController controller;
  SpriteTile({Key? key, required this.imageSrc, required this.controller})
      : super(key: key);

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpriteTileState extends State<SpriteTile> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    widget.controller._SetSpriteTileState(this);
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
          left: widget.controller.posX,
          top: widget.controller.posY,
          child: Container(
              width: widget.controller.widgetWidth,
              height: widget.controller.widgetHeight,
              child: SpriteRawTile(
                  image: image!,
                  tinyWidth: widget.controller.tinyWidth,
                  tinyHeight: widget.controller.tinyHeight,
                  spriteX: widget.controller.spriteX,
                  spriteY: widget.controller.spriteY)));
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

class SpriteController {
  double widgetWidth;
  double widgetHeight;
  double tinyWidth;
  double tinyHeight;
  double spriteX;
  double spriteY;
  double posX = 0;
  double posY = 0;
  _SpriteTileState? state;

  SpriteController(this.widgetWidth, this.widgetHeight, this.tinyWidth,
      this.tinyHeight, this.spriteX, this.spriteY);

  void _SetSpriteTileState(_SpriteTileState state) {
    this.state = state;
  }

  update() {
    if (state != null) {
      // ignore: invalid_use_of_protected_member
      state!.setState(() {
        // It will read the controller.
      });
    }
  }
}
