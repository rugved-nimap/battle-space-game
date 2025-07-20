import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
