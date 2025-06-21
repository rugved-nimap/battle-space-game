import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/component/enemy_bullet.dart';
import 'package:flutter_game/component/health_bar.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/flame/my_game.dart';

import '../controller/global_controller.dart';
import '../utils/asset_utils.dart';

class Enemy extends SpriteComponent with HasGameRef, CollisionCallbacks {
  GlobalController controller;
  final PositionComponent healthBar;

  Enemy({
    super.key,
    required Vector2 size,
    required Vector2 position,
    required this.healthBar,
    required this.controller,
  }) : super(size: size, position: position, priority: 2);

  double fireCoolDown = 1;
  double lastFireTime = 0.0;

  int hitCount = 0;

  // ignore: prefer_final_fields
  List<Sprite> _explosionSprites = [];

  @override
  FutureOr<void> onLoad() async {
    final spritePath = AssetUtils.enemySpriteList[Random().nextInt(AssetUtils.enemySpriteList.length)];
    sprite = await gameRef.loadSprite(AssetUtils.getLastTwoElementOfString(spritePath));
    add(RectangleHitbox(collisionType: CollisionType.active));

    _explosionSprites.addAll([
      await gameRef.loadSprite(AssetUtils.explosion0),
      await gameRef.loadSprite(AssetUtils.explosion1),
      await gameRef.loadSprite(AssetUtils.explosion2),
      await gameRef.loadSprite(AssetUtils.explosion3),
      await gameRef.loadSprite(AssetUtils.explosion4),
      await gameRef.loadSprite(AssetUtils.explosion5),
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
          animation: SpriteAnimation.spriteList(
            _explosionSprites,
            stepTime: 0.08,
            loop: false,
          ),
          removeOnFinish: true,
        ),
      );

      // final target = Vector2(gameRef.size.x - 60, 20);
      // const angleStep = (2 * pi) / 5;
      //
      // for (int i = 0; i < 5; i++) {
      //   final angle = angleStep * i + Random().nextDouble(); // randomize slightly
      //   final scatterDirection = Vector2(cos(angle), sin(angle));
      //
      //   gameRef.add(
      //     Coin(
      //       controller: controller,
      //       position: position.clone(),
      //       targetPosition: target,
      //       scatterDirection: scatterDirection,
      //     ),
      //   );
      // }

      (gameRef as MyGame).increaseScore();
      if (controller.isSfxOn) (gameRef as MyGame).explosionSoundPool.start();
      removeFromParent();
    }

    enemyBulletSpawn();
    lastFireTime += dt;
    super.update(dt);
  }

  void enemyBulletSpawn() {
    if (lastFireTime >= fireCoolDown) {
      final bullet = EnemyBullet(pos: Vector2(position.x + 22, position.y + 5), healthBar: (gameRef as MyGame).uiComponent.healthBar);
      gameRef.add(bullet);
      lastFireTime = 0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      (gameRef as MyGame).gameOverFunc();
      if (healthBar is HealthBar) {
        (healthBar as HealthBar).updateHearts(0);
      }
    }
  }
}
