import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/enemy_bullet.dart';
import 'package:flutter_game/component/enemy_type.dart';
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
    this.type = EnemyType.basic,
    this.speedMultiplier = 1.0,
    this.fireCoolDown = 1,
  }) : super(size: size, position: position, priority: 2);

  final EnemyType type;

  /// Grows with the level (see MyGame.enemySpeedMultiplier).
  final double speedMultiplier;

  double fireCoolDown;
  double lastFireTime = 0.0;

  double _time = 0;
  double _startX = 0;
  double _flashTime = 0;

  int hitCount = 0;

  // ignore: prefer_final_fields
  List<Sprite> _explosionSprites = [];

  @override
  FutureOr<void> onLoad() async {
    final spritePath = AssetUtils.enemySpriteList[Random().nextInt(AssetUtils.enemySpriteList.length)];
    sprite = await gameRef.loadSprite(AssetUtils.getLastTwoElementOfString(spritePath));
    add(RectangleHitbox(collisionType: CollisionType.active));
    _startX = position.x;
    _applyTint();

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
    if (_flashTime > 0) {
      _flashTime -= dt;
      if (_flashTime <= 0) _applyTint();
    }

    _move(dt);

    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
    if (gameRef is MyGame && hitCount >= type.maxHits) {
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

      (gameRef as MyGame).increaseScore(type.points);
      (gameRef as MyGame).onEnemyDestroyed(this);
      if (controller.isSfxOn) (gameRef as MyGame).explosionSoundPool.start();
      removeFromParent();
    }

    if (type.canShoot) enemyBulletSpawn();
    lastFireTime += dt;
    super.update(dt);
  }

  void _move(double dt) {
    final game = gameRef as MyGame;
    switch (type) {
      case EnemyType.basic:
        position.y += (2.5 + dt) * speedMultiplier; // original movement
      case EnemyType.zigzag:
        _time += dt;
        position.y += (2.0 + dt) * speedMultiplier;
        final maxX = max(0.0, game.size.x - size.x);
        position.x = (_startX + sin(_time * 3) * 70).clamp(0.0, maxX).toDouble();
      case EnemyType.kamikaze:
        position.y += (4.0 + dt) * speedMultiplier;
        // Home in on the player until level with it, then keep going straight.
        if (!game.gameOver && game.player.isMounted && position.y < game.player.position.y) {
          final targetX = game.player.position.x + game.player.size.x / 2 - size.x / 2;
          position.x += (targetX - position.x).clamp(-2.0, 2.0) * speedMultiplier;
        }
      case EnemyType.tank:
        position.y += (1.2 + dt) * speedMultiplier;
    }
  }

  /// Called by PlayerBullet when this enemy is hit.
  void takeHit() {
    hitCount += 1;
    _flashTime = 0.06;
    paint.colorFilter = const ColorFilter.mode(Colors.white, BlendMode.srcATop);
  }

  void _applyTint() {
    final tint = type.tint;
    paint.colorFilter = tint == null ? null : ColorFilter.mode(tint, BlendMode.srcATop);
  }

  void enemyBulletSpawn() {
    if (lastFireTime >= fireCoolDown) {
      final healthBar = (gameRef as MyGame).uiComponent.healthBar;
      if (type == EnemyType.tank) {
        // Two bullets, one from each side.
        for (final offset in [size.x * 0.25, size.x * 0.75]) {
          gameRef.add(EnemyBullet(pos: Vector2(position.x + offset - 12.5, position.y + size.y * 0.6), healthBar: healthBar));
        }
      } else {
        final x = type == EnemyType.basic ? position.x + 22 : position.x + size.x / 2 - 12.5;
        final bullet = EnemyBullet(pos: Vector2(x, position.y + 5), healthBar: healthBar);
        gameRef.add(bullet);
      }
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
