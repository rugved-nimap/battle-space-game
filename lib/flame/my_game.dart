import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/enemy.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/component/ui_component.dart';

class MyGame extends FlameGame with HasCollisionDetection {

  late BuildContext context;
  MyGame({required this.context}) : super();

  late Player _player;
  late SpriteComponent background1;
  late SpriteComponent background2;
  late TextComponent scoreText;
  late TextComponent distanceText;
  late TextComponent gameOverText;
  late UiComponent uiComponent;

  double enemyCoolDown = 2;
  double enemyLastSpawn = 0.0;

  bool gameOver = false;
  int score = 0;
  double distance = 0;

  @override
  FutureOr<void> onLoad() async {
    final bgSprite = await Sprite.load('background.jpg');
    background1 = SpriteComponent(
      sprite: bgSprite,
      size: Vector2(size.x, size.y),
      priority: 0,
    );
    background2 = SpriteComponent(
      sprite: bgSprite,
      size: Vector2(size.x, size.y),
      priority: 0,
    );

    background2.position = Vector2(0, size.y);

    add(background1);
    add(background2);

    _player = Player(size: Vector2(100, 100));
    add(_player);

    uiComponent =
        UiComponent(score: score, distance: distance, screenSize: size, context: context);
    add(uiComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    background1.position.y += 400 * dt;
    background2.position.y += 400 * dt;
    if (background1.position.y >= size.y) {
      background1.position.y = -size.y - 5;
    }
    if (background2.position.y >= size.y) {
      background2.position.y = -size.y - 5;
    }

    if (!gameOver) {
      if (enemyLastSpawn >= enemyCoolDown) {
        int xPos = Random().nextInt(size.x.round() - 50);
        final enemy = Enemy(
          size: Vector2(70, 70),
          position: Vector2(xPos.toDouble(), -50),
        );
        add(enemy);
        enemyLastSpawn = 0;
      }

      enemyLastSpawn += dt;
      distance += dt;

      uiComponent.updateDistance(distance);
    }

    super.update(dt);
  }

  void increaseScore() {
    score += 1;
    uiComponent.updateScore(score);
  }

  void gameOverFunc() async {
    gameOver = true;
    add(
      SpriteAnimationComponent(
        position: _player.position,
        priority: 3,
        size: Vector2(100, 100),
        animation:
        SpriteAnimation.spriteList([
          await loadSprite('explosions/0.png'),
          await loadSprite('explosions/1.png'),
          await loadSprite('explosions/2.png'),
          await loadSprite('explosions/3.png'),
          await loadSprite('explosions/4.png'),
          await loadSprite('explosions/5.png'),
        ], stepTime: 0.08, loop: false),
        removeOnFinish: true,
      ),
    );
    remove(_player);
    uiComponent.gameOver();
  }

  void restart() {
    removeAll(List.from(children));

    gameOver = false;
    score = 0;
    distance = 0;

    onLoad();
  }
}
