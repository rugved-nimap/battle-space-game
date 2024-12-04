import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_game/component/player_bullet.dart';

class Player extends SpriteComponent
    with HasGameRef, DragCallbacks, CollisionCallbacks {
  Player({super.key, required Vector2 size}) : super(size: size, priority: 2);

  double fireCooldown = 0.1;
  double lastFireTime = 0.0;

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('player.png');
    position =
        Vector2((gameRef.size.x / 2) - (size.x / 2), (gameRef.size.y - 150));
    add(RectangleHitbox(collisionType: CollisionType.active));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    lastFireTime += dt;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x += event.canvasDelta.x;
    playerBulletSpawn();
  }

  void playerBulletSpawn() {
    if (lastFireTime >= fireCooldown) {
      final bullet = PlayerBullet(pos: Vector2(position.x + 40, position.y));
      gameRef.add(bullet);
      lastFireTime = 0;
    }
  }
}
