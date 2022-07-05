import 'dart:typed_data';
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
      return SpriteRawTile(
          image: image!,
          tinyWidth: widget.controller.tinyWidth,
          tinyHeight: widget.controller.tinyHeight,
          posX: widget.controller.posX,
          posY: widget.controller.posY);
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
  double tinyWidth;
  double tinyHeight;
  double posX;
  double posY;
  _SpriteTileState? state;

  SpriteController(
      {required this.tinyWidth,
      required this.tinyHeight,
      required this.posX,
      required this.posY});

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
