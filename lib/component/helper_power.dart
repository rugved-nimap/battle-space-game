import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class HelperPower extends SpriteComponent with HasGameRef, CollisionCallbacks {
  HelperPower({
    super.key,
    required Vector2 size,
    required Vector2 pos,
  }) : super(size: size, position: pos);

  double lastSpawnTime = 0;
  double spawnInterval = 60;

  @override
  FutureOr<void> onLoad() async {
    final spritePath = AssetUtils.helperSpacecraft.split('/').last;
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
      other.getHelper();
      removeFromParent();
    }
  }
}
