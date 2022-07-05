import 'package:flutter/material.dart';
import 'package:ui/sprite/sprite_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _posX;
  late double _posY;
  late SpriteController _controller;
  @override
  void initState() {
    super.initState();
    _posX = 1;
    _posY = 0;
    _controller = SpriteController(
        tinyWidth: 24, tinyHeight: 24, posX: _posX * 1.0, posY: _posY);
    Future.doWhile(() async {
      await Future.delayed(const Duration(microseconds: 200), () {
        _onClick();
      });
      return true;
    });
  }

  void _onClick() {
    List<int> possibles = [1, 2, 3, 4, 5];
    int index = possibles.indexOf(_posX);
    if (++index >= possibles.length) {
      _posX = 1;
    } else {
      _posX = possibles[index];
    }
    _controller.posX = _posX * 1.0;
    _controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => _onClick(),
        child: Container(
          width: 80,
          height: 80,
          child: SpriteTile(
            imageSrc: 'images/character.png',
            controller: _controller,
          ),
        ),
      ),
    ]);
  }
}
