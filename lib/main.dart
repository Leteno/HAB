import 'dart:async';

import 'package:flutter/material.dart' hide Animation;
import 'package:hab_repo/game/example_scene.dart';
import 'package:hab_repo/game/game_over_scene.dart';
import 'package:ui/frame/fps.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';

import 'game/world.dart';

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
  late final Timer _timer;
  late Scene _currentScene;
  late GameOverScene gameOverScene;
  Fps fps = Fps();

  @override
  void initState() {
    super.initState();
    _currentScene = ExampleScene();
    gameOverScene = GameOverScene();

    var lastTime = DateTime.now();
    Timer.periodic(const Duration(milliseconds: 33), (Timer timer) {
      var currentTime = DateTime.now();
      int elapse = currentTime.difference(lastTime).inMilliseconds;
      lastTime = currentTime;

      gameOverScene.setVisible(World.instance.isGameOver);
      if (World.instance.isGameOver) {
        return;
      }

      // Animataion
      _currentScene.animate(elapse);
      fps.onFrameUpdated();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onKey(KeyEvent event) {
    GameEventType gEvent = GameEvent.translate(event);
    if (gameOverScene.isVisible()) {
      gameOverScene.onKey(gEvent);
      return;
    }
    _currentScene.onKey(gEvent);
  }

  @override
  Widget build(BuildContext context) {
    FocusNode node = FocusNode();
    return KeyboardListener(
        focusNode: node,
        onKeyEvent: onKey,
        child: Stack(children: [
          _currentScene.build(context),
          Positioned(
            left: 200,
            child: fps.build(),
          ),
          Positioned(left: 150, top: 200, child: gameOverScene.build()),
        ]));
  }
}
