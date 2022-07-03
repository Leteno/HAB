
import 'package:flutter/widgets.dart'

class SpriteTile extends StatefulWidget {
  const SpriteTile({Key? key, required this.imageSrc}) : super(key: key);

  final String imageSrc;

  @override
  State<SpriteTile> createState() => _SpriteTileState();
}

class _SpriteTileState extends State<SpriteTile> {

  @override
  Widget build(BuildContext context) {
    return Image.asset(widget.imageSrc);
  }
}