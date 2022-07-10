import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:ui/sprite/tile_position.dart';

class BulkSpriteRawTile extends StatelessWidget {
  final ui.Image image;
  double tileWidth;
  double tileHeight;
  double destWidth;
  double destHeight;
  List<TilePosition> tiles;
  BulkSpriteRawTile(this.image, this.tileWidth, this.tileHeight, this.destWidth,
      this.destHeight, this.tiles);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BulkSpritePainter(
          image, tileWidth, tileHeight, destWidth, destHeight, tiles),
    );
  }
}

class _BulkSpritePainter extends CustomPainter {
  final ui.Image image;
  double tileWidth;
  double tileHeight;
  double destWidth;
  double destHeight;
  List<TilePosition> tiles;

  _BulkSpritePainter(this.image, this.tileWidth, this.tileHeight,
      this.destWidth, this.destHeight, this.tiles);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    for (var tilePos in tiles) {
      Rect src = Rect.fromLTWH(tilePos.srcX * tileWidth,
          tilePos.srcY * tileHeight, tileWidth, tileHeight);
      Rect dst = Rect.fromLTWH(tilePos.dstX * destWidth,
          tilePos.dstY * destHeight, destWidth, destHeight);
      canvas.drawImageRect(image, src, dst, Paint());
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
