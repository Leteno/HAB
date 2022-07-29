import 'package:ui/data/game_tile_data.dart';

class WarriorTileData extends GameTileData {
  WarriorTileData() : super('images/character.png', 24, 24, 12, 12, 216, 192) {
    AnimationData idleAnimation = AnimationData();
    idleAnimation.animationIndexes
      ..add(SpriteIndex(1, 1))
      ..add(SpriteIndex(2, 1))
      ..add(SpriteIndex(3, 1))
      ..add(SpriteIndex(4, 1))
      ..add(SpriteIndex(5, 1));

    state2Animation[SpriteState.IDLE] = idleAnimation;

    AnimationData walkingAnimation = AnimationData();
    walkingAnimation.animationIndexes
      ..add(SpriteIndex(1, 0))
      ..add(SpriteIndex(2, 0))
      ..add(SpriteIndex(3, 0))
      ..add(SpriteIndex(4, 0))
      ..add(SpriteIndex(5, 0))
      ..add(SpriteIndex(1, 0));

    state2Animation[SpriteState.WALKING] = walkingAnimation;

    AnimationData jumpAnimation = AnimationData();
    jumpAnimation.animationIndexes.add(SpriteIndex(1, 2));
    state2Animation[SpriteState.JUMP] = jumpAnimation;

    AnimationData failAnimation = AnimationData();
    failAnimation.animationIndexes.add(SpriteIndex(3, 2));
    state2Animation[SpriteState.FAILING] = failAnimation;
  }
}
