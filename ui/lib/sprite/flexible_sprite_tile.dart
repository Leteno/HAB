import 'package:flutter/widgets.dart';
import 'package:ui/data/flexible_sprite_data.dart';
import 'package:ui/sprite/sprite.dart';
import 'dart:ui' as ui;
import 'package:ui/sprite/sprite_tile.dart';

/// In the past, we use sprite_tile or bulk_sprite_tile to draw something.
/// It will assume that the size is never changed.
/// e.g. Warrior tile, only one tile, and you never need to change the tile size
/// e.g. Map tile, all the grid size are the same. All is you need to switch the
/// position(indexX, indexY)
///
/// However, sometime we may need a flexible tile, it could select the any size
/// of picture pieces from image, it also supports draw several tile.
/// This is what this tile do.
class FlexibleSpriteTile extends StatefulWidget {
  String imageSrc;
  FlexibleSpriteData data;

  FlexibleSpriteTile(this.imageSrc, this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FlexibleSpriteTile();
  }
}

class _FlexibleSpriteTile extends State<FlexibleSpriteTile> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    widget.data.bindState(this);
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
        left: widget.data.posX,
        top: widget.data.posY,
        child: _FlexibleSpriteTileInternal(image!, widget.data),
      );
    }
    return const Text('Image loading');
  }
}

class _FlexibleSpriteTileInternal extends StatelessWidget {
  ui.Image image;
  FlexibleSpriteData data;
  _FlexibleSpriteTileInternal(this.image, this.data);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlexibleSpriteTilePainter(image, data),
    );
  }
}

class _FlexibleSpriteTilePainter extends CustomPainter {
  ui.Image image;
  FlexibleSpriteData data;

  _FlexibleSpriteTilePainter(this.image, this.data);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    for (var item in data.items) {
      canvas.drawImageRect(image, item.src, item.dst, Paint());
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
