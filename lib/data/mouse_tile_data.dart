import 'package:ui/data/game_tile_data.dart';

class MouseTileData extends GameTileData {
  MouseTileData() : super('images/rats.png', 20, 20, 10, 10, 160, 80) {
    AnimationData walkingAnimation = AnimationData();
    walkingAnimation.animationIndexes
      ..add(SpriteIndex(1, 0))
      ..add(SpriteIndex(2, 0))
      ..add(SpriteIndex(3, 0))
      ..add(SpriteIndex(4, 0))
      ..add(SpriteIndex(5, 0))
      ..add(SpriteIndex(6, 0))
      ..add(SpriteIndex(7, 0))
      ..add(SpriteIndex(1, 0));
    state2Animation[SpriteState.WALKING] = walkingAnimation;

    AnimationData faillingAnimation = AnimationData();
    faillingAnimation.animationIndexes.add(SpriteIndex(6, 0));
    state2Animation[SpriteState.FAILING] = faillingAnimation;
  }
}
