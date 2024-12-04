import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter_game/component/enemy.dart';

class PlayerBullet extends SpriteComponent with HasGameRef, CollisionCallbacks {
  PlayerBullet({super.key, required Vector2 pos})
      : super(position: pos, priority: 1);

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_bullet.png');
    size = Vector2(25, 25);

    add(RectangleHitbox(collisionType: CollisionType.active));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 300 * dt;

    if (position.y < (-gameRef.size.y)) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Enemy) {
      other.hitCount += 1;
      removeFromParent();
    }
  }
}
