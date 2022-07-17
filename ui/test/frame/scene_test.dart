import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/frame/game_map.dart';
import 'package:ui/frame/scene.dart';
import 'package:ui/keyboard/game_event.dart';

void main() {
  test('test animation', () {
    SceneForTest scene = SceneForTest();
    var anim1 = IntAnimation(1000, 0, 100);
    scene.animationMap['hello'] = anim1;
    var anim2 = DoubleAnimation(2000, 0, 100);
    scene.animationMap['world'] = anim2;

    expect(scene.animationMap.keys.length, 2);

    scene.animate(800);
    expect(anim1.value, 80);
    expect(anim2.value, 40);
    expect(scene.animationMap.keys.length, 2);

    scene.animate(300);
    expect(anim1.value, 100);
    expect(anim2.value, 55);
    expect(scene.animationMap.keys.length, 1);
    expect(scene.animationMap.containsKey('hello'), false);
    expect(scene.animationMap.containsKey('world'), true);

    scene.animate(1000);
    expect(anim2.value, 100);
    expect(scene.animationMap.keys.length, 0);
    expect(scene.animationMap.containsKey('world'), false);
  });

  test('animation onStop', () {
    SceneForTest scene = SceneForTest();
    double posY = 0;
    double origionalY = posY;
    DoubleAnimation jumpUp = DoubleAnimation(100, 0, 100);
    jumpUp.onValueChange = (value) {
      posY = origionalY + value;
    };
    jumpUp.onStop = () {
      DoubleAnimation jumpDown = DoubleAnimation(100, 100, 0);
      jumpDown.onValueChange = (value) {
        posY = origionalY + value;
      };
      scene.animationMap['jump'] = jumpDown;
    };
    scene.animationMap['jump'] = jumpUp;

    expect(posY, 0);

    // Start jumping up
    scene.animate(50);
    expect(posY, 50);
    scene.animate(50);
    expect(posY, 100);

    // Start falling down
    scene.animate(12);
    expect(posY, 88);
    scene.animate(100);
    expect(posY, 0);
  });
}

class SceneForTest extends Scene {
  @override
  Widget build(BuildContext context) {
    return Text("test");
  }

  @override
  void onKey(GameEventType event) {}

  @override
  GameMap getGameMap() {
    // TODO: implement getGameMap
    throw UnimplementedError();
  }
}
