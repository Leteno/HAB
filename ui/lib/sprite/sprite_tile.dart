import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;

class SpriteTile extends StatefulWidget {
  final String imageSrc;

  const SpriteTile({Key? key, required this.imageSrc}) : super(key: key);

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpritePainter extends CustomPainter {
  ui.Image? image;
  _SpritePainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.drawImage(image!, const Offset(0, 0), Paint());
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
      painter: _SpritePainter(image: _image),
    );
  }
}
