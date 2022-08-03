import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Fps {
  late DateTime lastTime;
  late _FpsTextView textView;
  Controller controller = Controller();

  Fps() {
    lastTime = DateTime.now();
    textView = _FpsTextView(controller);
  }

  void onFrameUpdated() {
    var current = DateTime.now();
    var fps = 1000 / (current.difference(lastTime).inMilliseconds);
    lastTime = current;
    controller.value = fps == double.infinity ? -1 : fps.ceil();
    controller.update();
  }

  Widget build() {
    return textView;
  }
}

class _FpsTextView extends StatefulWidget {
  Controller controller;
  _FpsTextView(this.controller);
  @override
  State<StatefulWidget> createState() {
    var state = _FpsState(controller);
    controller.bindState(state);
    return state;
  }
}

class _FpsState extends State<_FpsTextView> {
  Controller controller;
  _FpsState(this.controller);
  @override
  Widget build(BuildContext context) {
    return Text("FPS: ${controller.value}",
        style: const TextStyle(color: Colors.white, fontSize: 12));
  }
}

class Controller {
  int value = 0;
  late _FpsState state;
  void bindState(_FpsState state) {
    this.state = state;
  }

  void update() {
    this.state.setState(() {});
  }
}
