import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;

class SpriteRawTile extends StatelessWidget {
  final ui.Image image;
  double tinyWidth;
  double tinyHeight;
  double posX;
  double posY;

  SpriteRawTile(
      {Key? key,
      required this.image,
      required this.tinyWidth,
      required this.tinyHeight,
      required this.posX,
      required this.posY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(
          image: image,
          tinyWidth: tinyWidth,
          tinyHeight: tinyHeight,
          posX: posX,
          posY: posY),
    );
  }
}

class _SpritePainter extends CustomPainter {
  ui.Image image;
  double tinyWidth;
  double tinyHeight;
  double posX;
  double posY;

  _SpritePainter({
    required this.image,
    required this.tinyWidth,
    required this.tinyHeight,
    required this.posX,
    required this.posY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Rect src = Rect.fromLTWH(
        posX * tinyWidth, posY * tinyHeight, tinyWidth, tinyHeight);
    Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
