import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/component/enemy_bullet.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/flame/my_game.dart';

import '../controller/global_controller.dart';

class Enemy extends SpriteComponent with HasGameRef, CollisionCallbacks {

  GlobalController controller;
  Enemy({super.key, required Vector2 size, required Vector2 position, required this.controller})
      : super(size: size, position: position, priority: 2);

  double fireCooldown = 1;
  double lastFireTime = 0.0;

  int hitCount = 0;
  List<Sprite> _explosionSprites = [];

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy.png');
    add(RectangleHitbox(collisionType: CollisionType.active));

    _explosionSprites.addAll([
      await gameRef.loadSprite('explosions/0.png'),
      await gameRef.loadSprite('explosions/1.png'),
      await gameRef.loadSprite('explosions/2.png'),
      await gameRef.loadSprite('explosions/3.png'),
      await gameRef.loadSprite('explosions/4.png'),
      await gameRef.loadSprite('explosions/5.png'),
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += 2.5 + dt;

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
    if (gameRef is MyGame && hitCount >= 5) {
      gameRef.add(
        SpriteAnimationComponent(
          position: position,
          priority: 3,
          size: Vector2(100, 100),
          animation:
              SpriteAnimation.spriteList(_explosionSprites, stepTime: 0.08, loop: false,),
          removeOnFinish: true,
        ),
      );

      (gameRef as MyGame).increaseScore();
      print(controller.isSfxOn);
      if (controller.isSfxOn) (gameRef as MyGame).explosionSoundPool.start();
      removeFromParent();
    }

    enemyBulletSpawn();
    lastFireTime += dt;
    super.update(dt);
  }

  void enemyBulletSpawn() {
    if (lastFireTime >= fireCooldown) {
      final bullet = EnemyBullet(pos: Vector2(position.x + 22, position.y + 5));
      gameRef.add(bullet);
      lastFireTime = 0;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      (gameRef as MyGame).gameOverFunc();
    }
  }
}
