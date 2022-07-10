import 'dart:async';

import 'package:flutter/material.dart' hide Animation;
import 'package:hab_repo/game/example_scene.dart';
import 'package:ui/frame/scene.dart';

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
  @override
  void initState() {
    super.initState();
    _currentScene = ExampleScene();

    var lastTime = DateTime.now();
    Timer.periodic(const Duration(milliseconds: 33), (Timer timer) {
      var currentTime = DateTime.now();
      int elapse = currentTime.difference(lastTime).inMilliseconds;
      lastTime = currentTime;

      // Animataion
      _currentScene.animate(elapse);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onKey(KeyEvent event) {
    _currentScene.onKey(event);
  }

  @override
  Widget build(BuildContext context) {
    FocusNode node = FocusNode();
    return KeyboardListener(
        focusNode: node,
        onKeyEvent: onKey,
        child: _currentScene.build(context));
  }
}
