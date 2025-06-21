import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class Coin extends SpriteComponent with HasGameRef {
  GlobalController controller;
  final Vector2 targetPosition;

  Coin({
    super.key,
    required this.controller,
    required this.targetPosition,
    required Vector2 position,
    Vector2? size,
    required this.scatterDirection,
  }) : super(
    position: position,
    size: size ?? Vector2.all(32),
  );

  double speed = 100;
  late Vector2 scatterDirection;
  bool isScattering = true;
  double scatterDuration = 0.3; // seconds
  double scatterTimer = 0;


  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite(AssetUtils.coin.split('/').last);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isScattering) {
      scatterTimer += dt;
      position += scatterDirection * speed * dt;

      if (scatterTimer >= scatterDuration) {
        isScattering = false;
      }
    } else {
      final direction = (targetPosition - position).normalized();
      position += direction * speed * dt;

      if ((targetPosition - position).length < 10) {
        controller.userCoins += 5;
        AppStorage.setValue(StorageKey.userCoins, controller.userCoins);
        removeFromParent();
      }
    }
  }

}
