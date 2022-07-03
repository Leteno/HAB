import 'package:flutter/widgets.dart';

class SpriteTile extends StatefulWidget {
  const SpriteTile({Key? key, required this.imageSrc}) : super(key: key);

  final String imageSrc;

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpriteTileState extends State<SpriteTile> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _Clipper(),
      child: Image.asset(widget.imageSrc),
    );
  }
}

class _Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('${size}');
    final Path path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
