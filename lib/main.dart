import 'dart:async';

import 'package:flutter/material.dart' hide Animation;
import 'package:flutter/services.dart';
import 'package:ui/sprite/sprite_tile.dart';

import 'package:ui/animation/animation.dart' show Animation, IntAnimation;

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late int _humanPosX;
  late int _ratsPosX;
  late SpriteController _humanController;
  late SpriteController _ratController;
  late final Timer _timer;
  List<Animation> animationList = [];
  @override
  void initState() {
    super.initState();
    _humanPosX = 1;
    _ratsPosX = 1;
    _humanController = SpriteController(
        tinyWidth: 24, tinyHeight: 24, spriteX: _humanPosX * 1.0, spriteY: 0);
    _humanController.posX = 100;
    _humanController.posY = 100;
    _ratController = SpriteController(
        tinyWidth: 20, tinyHeight: 20, spriteX: _ratsPosX * 1.0, spriteY: 0);
    _ratController.posX = 0;
    _ratController.posY = 100;

    var lastTime = DateTime.now();
    Timer.periodic(const Duration(milliseconds: 33), (Timer timer) {
      var currentTime = DateTime.now();
      int elapse = currentTime.difference(lastTime).inMilliseconds;
      lastTime = currentTime;

      // Animataion
      List<Animation> nextAnimationList = [];
      for (var anim in animationList) {
        anim.elapse(elapse);
        if (!anim.isStop()) {
          nextAnimationList.add(anim);
        }
      }
      animationList = nextAnimationList;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
      IntAnimation animation = IntAnimation(1000, 1, 5);
      animation.onValueChange = (value) {
        _humanController.spriteX = value * 1.0;
        _humanController.update();
      };
      animationList.add(animation);
    }
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
