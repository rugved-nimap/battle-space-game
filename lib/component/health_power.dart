import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/component/health_bar.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class HealthPower extends SpriteComponent with HasGameRef, CollisionCallbacks {
  final PositionComponent healthBar;

  HealthPower({
    super.key,
    required Vector2 size,
    required Vector2 pos,
    required this.healthBar,
  }) : super(size: size, position: pos);

  double lastSpawnTime = 0;
  double spawnInterval = 60;

  @override
  FutureOr<void> onLoad() async {
    final spritePath = AssetUtils.health.split('/').last;
    sprite = await gameRef.loadSprite(spritePath);
    add(RectangleHitbox(collisionType: CollisionType.active));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 2.5 + dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      if (other.hitCount > 0) {
        other.hitCount -= 1;
        if (healthBar is HealthBar) {
          (healthBar as HealthBar).updateHearts(5 - other.hitCount);
        }
      }
      removeFromParent();
    }
  }
}
