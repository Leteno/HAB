import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;

import 'package:ui/ui.dart';

class SpriteRawTile extends StatelessWidget {
  final ui.Image image;
  double tinyWidth;
  double tinyHeight;
  double spriteX;
  double spriteY;

  SpriteRawTile(
      {Key? key,
      required this.image,
      required this.tinyWidth,
      required this.tinyHeight,
      required this.spriteX,
      required this.spriteY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(
          image: image,
          tinyWidth: tinyWidth,
          tinyHeight: tinyHeight,
          spriteX: spriteX,
          spriteY: spriteY),
    );
  }
}

class _SpritePainter extends CustomPainter {
  ui.Image image;
  double tinyWidth;
  double tinyHeight;
  double spriteX;
  double spriteY;

  _SpritePainter({
    required this.image,
    required this.tinyWidth,
    required this.tinyHeight,
    required this.spriteX,
    required this.spriteY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Rect src = Rect.fromLTWH(
        spriteX * tinyWidth, spriteY * tinyHeight, tinyWidth, tinyHeight);
    Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    if (isDebug) {
      // Draw area
      canvas.drawRect(dst, Paint()..color = Colors.white70);
      // Collision area
      canvas.drawRect(
          Rect.fromLTWH(
              size.width / 4, size.height / 4, size.width / 2, size.height / 2),
          Paint()..color = Colors.black54);
    }
    canvas.drawImageRect(image, src, dst, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
