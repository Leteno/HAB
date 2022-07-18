/*
 * This is a DAO, store the data related to tile painting, such as
 * * tile image name
 * * tile size
 * * tile actual size (In png, some area are transparent, and for collision detection, we may need to know the actual size.)
 */
import 'package:flutter/cupertino.dart';
import 'package:ui/animation/animation.dart';

class GameTileData {
  final String imagePath;
  final double tileWidth;
  final double tileHeight;
  final double tileActualWidth;
  final double tileActualHeight;

  final double imageWidth;
  final double imageHeight;
  double imageSpriteStartPoxX = 0;
  double imageSpriteStartPoxY = 0;
  int imageSpriteIndexX = 1;
  int imageSpriteIndexY = 0;
  bool reverseDirection = false;

  Map<String, AnimationData> state2Animation = {};

  GameTileData(
      this.imagePath,
      this.tileWidth,
      this.tileHeight,
      this.tileActualWidth,
      this.tileActualHeight,
      this.imageWidth,
      this.imageHeight);

  AnimationData getAnimationData(String state) {
    assert(state2Animation[state] != null);
    AnimationData? result = state2Animation[state];
    return result!;
  }
}

class SpriteState {
  static String IDLE = "IDLE";
  static String WALKING = "WALKING";
  static String JUMP = "JUMP";
}

typedef UpdateFunc = void Function();

class AnimationData {
  double imageSpriteStartPosX = 0;
  double imageSpriteStartPosY = 0;
  List<SpriteIndex> animationIndexes = [];

  IntAnimation buildAnimation(
    int msDuration,
    GameTileData tileData,
    UpdateFunc updateFunc,
  ) {
    IntAnimation animation =
        IntAnimation(msDuration, 0, animationIndexes.length - 1);
    animation.onValueChange = (value) {
      SpriteIndex spriteIndex = animationIndexes[value];
      tileData.imageSpriteIndexX = spriteIndex.x;
      tileData.imageSpriteIndexY = spriteIndex.y;
      updateFunc();
    };
    return animation;
  }
}

class SpriteIndex {
  int x;
  int y;
  SpriteIndex(this.x, this.y);
}
