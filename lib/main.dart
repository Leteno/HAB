import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late int _humanPosX;
  late int _ratsPosX;
  late SpriteController _humanController;
  late SpriteController _ratController;
  @override
  void initState() {
    super.initState();
    _humanPosX = 1;
    _ratsPosX = 1;
    _humanController = SpriteController(
        tinyWidth: 24, tinyHeight: 24, spriteX: _humanPosX * 1.0, spriteY: 0);
    _ratController = SpriteController(
        tinyWidth: 20, tinyHeight: 20, spriteX: _ratsPosX * 1.0, spriteY: 0);
    Future.doWhile(() async {
      await Future.delayed(const Duration(microseconds: 200), () {
        _onClick();
      });
      return true;
    });
  }

  void _onClick() {
    // List<int> possibles = [1, 2, 3, 4, 5];
    // int index = possibles.indexOf(_humanPosX);
    // if (++index >= possibles.length) {
    //   _humanPosX = 1;
    // } else {
    //   _humanPosX = possibles[index];
    // }
    // _humanController.posX = _humanPosX * 1.0;
    // _humanController.update();

    // List<int> ratsPossible = [1, 2, 3, 4, 5, 6, 7];
    // index = possibles.indexOf(_ratsPosX);
    // if (++index >= ratsPossible.length) {
    //   _ratsPosX = 1;
    // } else {
    //   _ratsPosX = ratsPossible[index];
    // }
    // _ratController.posX = _ratsPosX * 1.0;
    // _ratController.update();
  }

  void onKey(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      print("press left");
      _ratController.posX += 10;
      _ratController.update();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      print("press right");
      _humanController.posX += 10;
      _humanController.update();
    }
    print('${event}');
  }

  @override
  Widget build(BuildContext context) {
    FocusNode node = FocusNode();
    return KeyboardListener(
      focusNode: node,
      onKeyEvent: onKey,
      child: Stack(
        children: [
          SpriteTile(
            imageSrc: 'images/rats.png',
            controller: _ratController,
          ),
          SpriteTile(
            imageSrc: 'images/character.png',
            controller: _humanController,
          ),
          const Text("小嘉嘉快跑~~"),
        ],
      ),
    );
  }
}
