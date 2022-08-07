import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Paired with flexible_sprite_tile.dart, FlexibleSpriteData will record the
/// range tile from the source image ${FlexibileSpriteDataItem.src} to the range
/// of the target area ${FlexibleSpriteDataItem.dst}.
/// Normally, dst's {top, left} would be simple as 0, tileSize*i
/// We will put the position to ${FlexibleSpriteData.posX} and ${posY}, and dst
/// only store the data related to it.
class FlexibleSpriteData {
  double posX;
  double posY;
  List<FlexibleSpriteDataItem> items = [];
  FlexibleSpriteData(this.posX, this.posY);

  bool dirty = true;

  update() {
    dirty = true;
  }
}

// For every grid
class FlexibleSpriteDataItem {
  Rect src;
  Rect dst;

  FlexibleSpriteDataItem(this.src, this.dst);
}
