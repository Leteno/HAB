import 'package:flutter/widgets.dart';
import 'package:ui/keyboard/game_event.dart';

class GameOverScene {
  _Controller controller = _Controller();

  GameOverScene();

  void setVisible(bool visible) {
    if (visible != controller.visible) {
      controller.visible = visible;
      controller.update();
    }
  }

  void onKey(GameEventType event) {}

  bool isVisible() {
    return controller.visible;
  }

  Widget build() {
    return _GameOverView(controller);
  }
}

class _Controller {
  bool visible = false;
  State? state;

  bindState(State state) {
    this.state = state;
  }

  void update() {
    state?.setState(() {});
  }
}

class _GameOverView extends StatefulWidget {
  _Controller controller;
  _GameOverView(this.controller);

  @override
  State<StatefulWidget> createState() {
    return _GameOverViewState();
  }
}

class _GameOverViewState extends State<_GameOverView> {
  _GameOverViewState();

  @override
  void initState() {
    super.initState();
    widget.controller.bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.controller.visible, child: Text("Game Over"));
  }
}
