import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/component/player.dart';

class EnemyBullet extends SpriteComponent with HasGameRef, CollisionCallbacks {
  EnemyBullet({super.key, required Vector2 pos})
      : super(position: pos, priority: 1);

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy_bullet.png');
    size = Vector2(25, 25);

    add(RectangleHitbox(collisionType: CollisionType.active));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 300 * dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      other.hitCount += 1;
      removeFromParent();
    }
  }
}
