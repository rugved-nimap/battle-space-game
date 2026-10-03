import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/helper_spacecraft.dart';
import 'package:flutter_game/component/player_bullet.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/flame/my_game.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class Player extends PositionComponent with HasGameRef, DragCallbacks, CollisionCallbacks {
  GlobalController controller;

  Player({
    super.key,
    required Vector2 size,
    required this.controller,
  }) : super(size: size, priority: 2);

  double fireCoolDown = 0.1;
  double lastFireTime = 0.0;
  int hitCount = 0;
  late final SpriteComponent sprite;

  double _flashTime = 0;
  double _trailTime = 0;
  final Random _rng = Random();

  @override
  FutureOr<void> onLoad() async {
    sprite = SpriteComponent(
      sprite: await gameRef.loadSprite(AssetUtils.getLastTwoElementOfString(controller.playerSprite)),
      size: size,
    );
    // sprite = await gameRef.loadSprite(AssetUtils.getLastTwoElementOfString(controller.playerSprite));
    position = Vector2((gameRef.size.x / 2) - (size.x / 2), (gameRef.size.y - 150));
    add(sprite);

    final hitBox = RectangleHitbox(
      collisionType: CollisionType.active,
      size: Vector2(50, 50),
      position: Vector2(size.x * 0.25, size.y * 0.25),
    );
      // ..debugMode = true;  // Enable it to visualize the HitBox.

    add(hitBox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    lastFireTime += dt;

    // Red flash after being hit.
    if (_flashTime > 0) {
      _flashTime -= dt;
      if (_flashTime <= 0) sprite.paint.colorFilter = null;
    }

    // Engine trail.
    _trailTime += dt;
    if (_trailTime >= 0.04) {
      _trailTime = 0;
      _spawnTrail();
    }

    // Controls: auto-fire shoots without dragging.
    if (controller.autoFire) playerBulletSpawn();

    if (hitCount >= 5) {
      (gameRef as MyGame).gameOverFunc();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x += event.canvasDelta.x;
    playerBulletSpawn();
  }

  /// Controls: with "drag anywhere" on, a drag started anywhere on the screen
  /// moves the ship (not only a drag that starts on the ship).
  @override
  bool containsLocalPoint(Vector2 point) => controller.dragAnywhere || super.containsLocalPoint(point);

  /// Called by MyGame.onPlayerHit.
  void flashHit() {
    _flashTime = 0.15;
    sprite.paint.colorFilter = ColorFilter.mode(Colors.red.withValues(alpha: 0.7), BlendMode.srcATop);
  }

  void _spawnTrail() {
    final color = _rng.nextBool() ? Colors.orangeAccent : Colors.lightBlueAccent;
    gameRef.add(
      ParticleSystemComponent(
        position: position + Vector2(size.x / 2 + (_rng.nextDouble() * 10 - 5), size.y * 0.85),
        priority: 1,
        particle: AcceleratedParticle(
          lifespan: 0.35,
          speed: Vector2(_rng.nextDouble() * 30 - 15, 160 + _rng.nextDouble() * 60),
          child: CircleParticle(
            radius: 2 + _rng.nextDouble() * 2,
            paint: Paint()..color = color.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  void getHelper() {
    final hasHelper = children.whereType<HelperSpacecraft>().isNotEmpty;
    if (hasHelper) return;
    add(HelperSpacecraft(size: Vector2(50, 50), position: Vector2(-50, 50), controller: controller));
    add(HelperSpacecraft(size: Vector2(50, 50), position: Vector2(100, 50), controller: controller));
  }

  void playerBulletSpawn() {
    if (lastFireTime >= fireCoolDown) {
      final bullet = PlayerBullet(pos: Vector2(position.x + 40, position.y));
      gameRef.add(bullet);

      if (controller.isSfxOn) {
        (gameRef as MyGame).fireSoundPool.start();
      }

      lastFireTime = 0;
    }
  }
}
