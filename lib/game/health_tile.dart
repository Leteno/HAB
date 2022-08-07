import 'package:flutter/widgets.dart';
import 'package:ui/data/flexible_sprite_data.dart';
import 'package:ui/sprite/bulk_sprite_tile.dart';
import 'package:ui/sprite/flexible_sprite_tile.dart';
import 'package:ui/sprite/tile_position.dart';

class HealthTile {
  double heartSize = 12;
  late final FlexibleSpriteData _data;
  HealthController healthController = HealthController();
  HealthTile() {
    _data = FlexibleSpriteData(0, 0);
    healthController.updateInternal = () {
      _data.items.clear();
      for (int i = 0; i < healthController.currentHealth; i++) {
        _data.items.add(FlexibleSpriteDataItem(Rect.fromLTWH(69, 501, 6, 6),
            Rect.fromLTWH(heartSize * i, 0, heartSize, heartSize)));
      }
      for (int i = healthController.currentHealth;
          i < healthController.health;
          i++) {
        _data.items.add(FlexibleSpriteDataItem(Rect.fromLTWH(85, 501, 6, 6),
            Rect.fromLTWH(heartSize * i, 0, heartSize, heartSize)));
      }
      _data.update();
    };
  }

  void reposition(double posX, double posY) {
    _data.posX = posX;
    _data.posY = posY;
    _data.update();
  }

  Widget build() {
    return FlexibleSpriteTile('images/background_tile.png', _data);
  }
}

typedef UpdateInternal = void Function();

class HealthController {
  int health = 3;
  int currentHealth = 2;
  UpdateInternal? updateInternal;

  void update() {
    updateInternal?.call();
  }
}
