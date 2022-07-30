import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ui/data/game_tile_data.dart';

import 'dart:ui' as ui;

import 'package:ui/ui.dart';

class SpriteRawTile extends StatelessWidget {
  final ui.Image image;
  GameTileData tileData;
  bool visible;

  SpriteRawTile(
      {Key? key,
      required this.image,
      required this.tileData,
      required this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(image, tileData, visible),
    );
  }
}

class _SpritePainter extends CustomPainter {
  ui.Image image;
  GameTileData tileData;
  bool visible;

  _SpritePainter(this.image, this.tileData, this.visible);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Rect src = Rect.fromLTWH(
        tileData.imageSpriteStartPoxX +
            tileData.imageSpriteIndexX * tileData.tileWidth,
        tileData.imageSpriteStartPoxY +
            tileData.imageSpriteIndexY * tileData.tileHeight,
        tileData.tileWidth,
        tileData.tileHeight);
    // Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect dst = Rect.fromLTRB(0, 0, size.width, size.height);
    if (isDebug) {
      // Draw area
      canvas.drawRect(dst, Paint()..color = Colors.white70);
      // Collision area
      canvas.drawRect(
          Rect.fromLTWH(
            size.width *
                (1.0 - tileData.tileActualWidth / tileData.tileWidth) /
                2,
            size.height *
                (1.0 - tileData.tileActualHeight / tileData.tileHeight) /
                2,
            size.width * tileData.tileActualWidth / tileData.tileWidth,
            size.height * tileData.tileActualHeight / tileData.tileHeight,
          ),
          Paint()..color = Colors.black54);
    }
    if (tileData.reverseDirection) {
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    }
    if (visible) {
      canvas.drawImageRect(image, src, dst, Paint());
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
