import 'package:flame/components.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class HealthBar extends PositionComponent with HasGameRef {
  final double spacing;
  final double heartSize;

  final List<SpriteComponent> _hearts = [];

  HealthBar({
    this.spacing = 4,
    this.heartSize = 24,
    Vector2? position,
  }) {
    this.position = position ?? Vector2(10, 10);
    size = Vector2((heartSize + spacing) * maxHearts, heartSize);
    anchor = Anchor.topLeft;
  }

  final int maxHearts = 5;
  late final Sprite heart;

  @override
  Future<void> onLoad() async {
    heart = await gameRef.loadSprite(AssetUtils.health.split('/').last);

    for (int i = 0; i < maxHearts; i++) {
      final h = SpriteComponent(
        sprite: heart,
        size: Vector2.all(heartSize),
        position: Vector2((heartSize + spacing) * i, 0),
      );
      _hearts.add(h);
      add(h);
    }
    updateHearts(5);
  }

  void updateHearts(int currentHealth) {
    for (int i = 0; i < _hearts.length; i++) {
      _hearts[i].removeFromParent();
    }
    _hearts.clear();

    for (int i = 0; i < currentHealth && i < maxHearts; i++) {
      final h = SpriteComponent(
        sprite: heart,
        size: Vector2.all(heartSize),
        position: Vector2((heartSize + spacing) * i, 0),
      );
      _hearts.add(h);
      add(h);
    }
  }
}
