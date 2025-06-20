import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_game/component/enemy.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/component/ui_component.dart';
import 'package:flutter_game/controller/global_controller.dart';

class MyGame extends FlameGame with HasCollisionDetection {
  GlobalController controller;

  MyGame({required this.controller}) : super();

  late Player _player;
  late SpriteComponent background1;
  late SpriteComponent background2;
  late TextComponent scoreText;
  late TextComponent distanceText;
  late TextComponent gameOverText;
  late UiComponent uiComponent;

  double enemyCoolDown = 2;
  double enemyLastSpawn = 0.0;

  bool initialized = false;
  bool gameOver = false;
  int score = 0;
  double distance = 0;

  late AudioPool fireSoundPool;
  late AudioPool explosionSoundPool;

  @override
  FutureOr<void> onLoad() async {
    fireSoundPool = controller.fireSoundPool;
    explosionSoundPool = controller.explosionSoundPool;

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

    _player = Player(size: Vector2(100, 100), controller: controller);
    add(_player);

    uiComponent = UiComponent(score: score, distance: distance, screenSize: size);
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
        final enemy = Enemy(size: Vector2(70, 70), position: Vector2(xPos.toDouble(), -50), controller: controller);
        add(enemy);
        enemyLastSpawn = 0;
      }

      enemyLastSpawn += dt;
      distance += dt;

      uiComponent.updateDistance(distance);
    }

    super.update(dt);
  }

  @override
  void onDispose() {
    fireSoundPool.dispose();
    explosionSoundPool.dispose();
    super.onDispose();
  }

  void initializedAudioPool() async {
    fireSoundPool = await FlameAudio.createPool('fire.wav', maxPlayers: 100, minPlayers: 1);
    explosionSoundPool = await FlameAudio.createPool('explosion.mp3', maxPlayers: 100, minPlayers: 1);
  }

  void increaseScore() {
    score += 1;
    uiComponent.updateScore(score);
  }

  void gameOverFunc() async {
    gameOver = true;

    if (controller.isSfxOn) {
      explosionSoundPool.start();
    }
    add(
      SpriteAnimationComponent(
        position: _player.position,
        priority: 3,
        size: Vector2(100, 100),
        animation: SpriteAnimation.spriteList([
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

  Future<void> restart() async {
    removeAll(children);

    gameOver = false;
    score = 0;
    distance = 0;

    onLoad();
  }
}
