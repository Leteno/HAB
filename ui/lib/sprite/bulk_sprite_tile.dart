import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ui/sprite/sprite_raw_tile.dart';

import 'bulk_sprite_raw_tile.dart';

class BulkSpriteTile extends StatefulWidget {
  String imageSrc;
  BulkSpriteController controller;

  BulkSpriteTile(this.imageSrc, this.controller);

  @override
  State<StatefulWidget> createState() => _BulkSpriteTileState();
}

class _BulkSpriteTileState extends State<BulkSpriteTile> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    widget.controller._SetBulkSpriteTileState(this);
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
          child: BulkSpriteRawTile(
              image!,
              widget.controller.tileWidth,
              widget.controller.tileHeight,
              widget.controller.destWidth,
              widget.controller.destHeight,
              widget.controller.tiles));
    }
    return const Text('image loading');
  }
}

class BulkSpriteController {
  double tileWidth;
  double tileHeight;
  double destWidth;
  double destHeight;
  List<TilePosition> tiles = [];

  double posX = 0;
  double posY = 0;

  _BulkSpriteTileState? state;

  BulkSpriteController(
      this.tileWidth, this.tileHeight, this.destWidth, this.destHeight);

  void _SetBulkSpriteTileState(_BulkSpriteTileState state) {
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

Future<ui.Image> getAssetImage(String imageSrc) async {
  ByteData data = await rootBundle.load(imageSrc);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}
