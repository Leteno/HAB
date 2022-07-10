import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/animation/animation.dart';
import 'package:ui/frame/scene.dart';

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
}

class SceneForTest extends Scene {
  @override
  Widget build(BuildContext context) {
    return Text("test");
  }

  @override
  void onKey(KeyEvent event) {}
}
