import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;

class SpriteTile extends StatefulWidget {
  final String imageSrc;
  double tinyWidth;
  double tinyHeight;
  double posX;
  double posY;

  SpriteTile(
      {Key? key,
      required this.imageSrc,
      required this.tinyWidth,
      required this.tinyHeight,
      required this.posX,
      required this.posY})
      : super(key: key);

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpritePainter extends CustomPainter {
  ui.Image? image;
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
    Rect dst =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    canvas.drawImageRect(image!, src, dst, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _SpriteTileState extends State<SpriteTile> {
  ui.Image? _image;
  @override
  void initState() {
    super.initState();
    _getAssetImage();
  }

  void _getAssetImage() async {
    ByteData data = await rootBundle.load(widget.imageSrc);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      _image = fi.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpritePainter(
          image: _image,
          tinyWidth: widget.tinyWidth,
          tinyHeight: widget.tinyHeight,
          posX: widget.posX,
          posY: widget.posY),
    );
  }
}
