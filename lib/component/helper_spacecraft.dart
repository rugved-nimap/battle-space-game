import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/component/player_bullet.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/flame/my_game.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class HelperSpacecraft extends SpriteComponent with HasGameRef {
  GlobalController controller;

  HelperSpacecraft({
    super.key,
    required Vector2 size,
    required Vector2 position,
    required this.controller,
  }) : super(size: size, position: position, priority: 2);

  double fireCoolDown = 0.2;
  double lastFireTime = 0;

  double time = 0;
  double spawnTime = 15;

  @override
  FutureOr<void> onLoad() async {
    final spritePath = AssetUtils.helperSpacecraft.split('/').last;
    sprite = await gameRef.loadSprite(spritePath);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    lastFireTime += dt;
    time += dt;
    if (time >= spawnTime) {
      removeFromParent();
    }
    if (gameRef is MyGame) {
      if (!(gameRef as MyGame).gameOver) {
        fire();
      }
    }
  }

  void fire() {
    if (lastFireTime >= fireCoolDown) {
      final bullet = PlayerBullet(pos: absolutePosition + Vector2((size.x / 2) - 12.5, 0));
      gameRef.add(bullet);

      if (controller.isSfxOn) {
        (gameRef as MyGame).fireSoundPool.start();
      }
      lastFireTime = 0;
    }
  }
}
