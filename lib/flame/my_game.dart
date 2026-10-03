import 'dart:async';
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/coin.dart';
import 'package:flutter_game/component/enemy.dart';
import 'package:flutter_game/component/enemy_type.dart';
import 'package:flutter_game/component/health_power.dart';
import 'package:flutter_game/component/helper_power.dart';
import 'package:flutter_game/component/player.dart';
import 'package:flutter_game/component/ui_component.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/utils/asset_utils.dart';

class MyGame extends FlameGame with HasCollisionDetection {
  GlobalController controller;

  MyGame({required this.controller}) : super();

  // Names of the Flutter overlays registered in GameWidgetPage.
  static const pauseButtonOverlay = 'pauseButton';
  static const pauseMenuOverlay = 'pauseMenu';

  final Random _rng = Random();

  late Player _player;
  late SpriteComponent background1;
  late SpriteComponent background2;
  late TextComponent scoreText;
  late TextComponent distanceText;
  late TextComponent gameOverText;
  late UiComponent uiComponent;

  double enemyCoolDown = 2;
  double enemyLastSpawn = 0.0;

  double powerCoolDown = 10;
  double powerLastSpawn = 0.0;

  bool initialized = false;
  bool gameOver = false;
  int score = 0;
  double distance = 0;

  late AudioPool fireSoundPool;
  late AudioPool explosionSoundPool;

  /// Used by enemies (kamikaze steering).
  Player get player => _player;

  // ---------- Rising difficulty ----------

  /// Goes up every 20 seconds of flight, up to level 10.
  int get level => min(10, 1 + distance ~/ 20);

  /// Seconds between enemy spawns: 2.0 at level 1 down to 0.7.
  double get enemySpawnCoolDown => max(0.7, 2.0 - (level - 1) * 0.15);

  /// 1.0 at level 1 up to 1.72 at level 10.
  double get enemySpeedMultiplier => 1 + (level - 1) * 0.08;

  /// Seconds between enemy shots: 1.0 at level 1 down to 0.5.
  double get enemyFireCoolDown => max(0.5, 1.0 - (level - 1) * 0.06);

  int _shownLevel = 1;

  // ---------- Coin drops ----------

  /// Coins picked up from destroyed enemies in this run.
  int runCoins = 0;

  // ---------- Game feel ----------
  double _shakeTime = 0;
  double _shakeDuration = 0;
  double _shakeIntensity = 0;
  double _damageFlash = 0;
  static const double _damageFlashDuration = 0.3;

  @override
  FutureOr<void> onLoad() async {
    fireSoundPool = controller.fireSoundPool;
    explosionSoundPool = controller.explosionSoundPool;

    final bgSprite = await Sprite.load(AssetUtils.background.split('/').last);
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

    uiComponent = UiComponent(score: score, distance: distance, screenSize: size, level: level, coins: runCoins);
    add(uiComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_shakeTime > 0) _shakeTime -= dt;
    if (_damageFlash > 0) _damageFlash -= dt;

    background1.position.y += 400 * dt;
    background2.position.y += 400 * dt;
    if (background1.position.y >= size.y) {
      background1.position.y = -size.y - 5;
    }
    if (background2.position.y >= size.y) {
      background2.position.y = -size.y - 5;
    }

    if (!gameOver) {
      if (powerLastSpawn >= powerCoolDown) {
        int xPos = Random().nextInt(size.x.round() - 50);
        late final SpriteComponent power;
        if (xPos.isEven) {
          power = HealthPower(
            size: Vector2(50, 50),
            pos: Vector2(xPos.toDouble(), -50),
            healthBar: uiComponent.healthBar,
          );

        } else {
          power = HelperPower(
            size: Vector2(50, 50),
            pos: Vector2(xPos.toDouble(), -50),
          );
        }
        add(power);
        powerLastSpawn = 0;
      }

      enemyCoolDown = enemySpawnCoolDown;
      if (enemyLastSpawn >= enemyCoolDown) {
        final type = pickEnemyType();
        int xPos = Random().nextInt(size.x.round() - 50);
        if (type == EnemyType.tank) xPos = min(xPos, (size.x - type.size).round());
        final enemy = Enemy(
          size: Vector2.all(type.size),
          position: Vector2(xPos.toDouble(), -50),
          controller: controller,
          healthBar: uiComponent.healthBar,
          type: type,
          speedMultiplier: enemySpeedMultiplier,
          fireCoolDown: enemyFireCoolDown,
        );
        add(enemy);
        enemyLastSpawn = 0;
      }

      powerLastSpawn += dt;
      enemyLastSpawn += dt;
      distance += dt;

      uiComponent.updateDistance(distance);

      if (level > _shownLevel) {
        _shownLevel = level;
        uiComponent.showLevelUp(level);
        controller.hapticLight();
      }
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
    fireSoundPool = await FlameAudio.createPool(AssetUtils.firingSound, maxPlayers: 100, minPlayers: 1);
    explosionSoundPool = await FlameAudio.createPool(AssetUtils.explosionSound, maxPlayers: 100, minPlayers: 1);
  }

  void increaseScore([int points = 1]) {
    score += points;
    uiComponent.updateScore(score);
  }

  void gameOverFunc() async {
    gameOver = true;
    overlays.remove(pauseButtonOverlay);
    shake(0.5, 12);
    controller.hapticHeavy();

    if (controller.isSfxOn) {
      explosionSoundPool.start();
    }

    add(
      SpriteAnimationComponent(
        position: _player.position,
        priority: 3,
        size: Vector2(100, 100),
        animation: SpriteAnimation.spriteList(
          [
            await loadSprite(AssetUtils.explosion0),
            await loadSprite(AssetUtils.explosion1),
            await loadSprite(AssetUtils.explosion2),
            await loadSprite(AssetUtils.explosion3),
            await loadSprite(AssetUtils.explosion4),
            await loadSprite(AssetUtils.explosion5),
          ],
          stepTime: 0.08,
          loop: false,
        ),
        removeOnFinish: true,
      ),
    );
    remove(_player);
    controller.getRank(score.toString());
    uiComponent.gameOver();
  }

  Future<void> continueGame(num score, num distance) async {
    removeAll(children);

    gameOver = false;
    score = score;
    distance = distance;
    _shownLevel = level;
    _resetEffects();
    overlays.add(pauseButtonOverlay);

    onLoad();
  }

  Future<void> restart() async {
    removeAll(children);

    gameOver = false;
    score = 0;
    distance = 0;
    _shownLevel = 1;
    runCoins = 0;
    _resetEffects();
    overlays.add(pauseButtonOverlay);

    onLoad();
  }

  // ---------- Enemy types ----------

  /// Stronger enemies unlock as the level rises.
  EnemyType pickEnemyType() {
    final roll = _rng.nextDouble();
    if (level >= 4 && roll < 0.12) return EnemyType.tank;
    if (level >= 3 && roll < 0.30) return EnemyType.kamikaze;
    if (level >= 2 && roll < 0.55) return EnemyType.zigzag;
    return EnemyType.basic;
  }

  /// Called by Enemy when it is destroyed by the player.
  void onEnemyDestroyed(Enemy enemy) {
    final center = enemy.position + enemy.size / 2;
    final isTank = enemy.type == EnemyType.tank;
    _spawnExplosionParticles(center, isTank ? 40 : 18);
    _spawnFloatingText("+${enemy.type.points}", center);
    _dropCoins(center, enemy.type.coins);
    shake(isTank ? 0.3 : 0.12, isTank ? 8 : 3);
    controller.hapticLight();
  }

  // ---------- Coin drops ----------

  void _dropCoins(Vector2 from, int count) {
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i + _rng.nextDouble();
      add(
        Coin(
          controller: controller,
          position: from.clone(),
          size: Vector2.all(20),
          value: 1,
          targetPosition: uiComponent.coinTarget,
          scatterDirection: Vector2(cos(angle), sin(angle)),
          onCollected: _onCoinCollected,
        )..speed = 350,
      );
    }
  }

  void _onCoinCollected(int value) {
    runCoins += value;
    uiComponent.updateCoins(runCoins);
  }

  // ---------- Game feel ----------

  /// Called by EnemyBullet when the player loses a heart.
  void onPlayerHit() {
    shake(0.25, 6);
    _damageFlash = _damageFlashDuration;
    controller.hapticMedium();
    if (_player.isMounted) _player.flashHit();
  }

  /// Shakes the whole screen. A weaker shake never cuts a stronger one short.
  void shake(double duration, double intensity) {
    if (_shakeTime > 0 && intensity < _shakeIntensity) return;
    _shakeDuration = duration;
    _shakeTime = duration;
    _shakeIntensity = intensity;
  }

  void _resetEffects() {
    _shakeTime = 0;
    _damageFlash = 0;
  }

  void _spawnExplosionParticles(Vector2 at, int count) {
    const colors = [Colors.orangeAccent, Colors.yellowAccent, Colors.deepOrange, Colors.white];
    add(
      ParticleSystemComponent(
        position: at,
        priority: 3,
        particle: Particle.generate(
          count: count,
          lifespan: 0.6,
          generator: (i) {
            final angle = _rng.nextDouble() * 2 * pi;
            final speed = 60 + _rng.nextDouble() * 160;
            return AcceleratedParticle(
              speed: Vector2(cos(angle), sin(angle)) * speed,
              acceleration: Vector2(0, 150),
              child: CircleParticle(
                radius: 1.5 + _rng.nextDouble() * 2.5,
                paint: Paint()..color = colors[i % colors.length],
              ),
            );
          },
        ),
      ),
    );
  }

  void _spawnFloatingText(String text, Vector2 at) {
    add(
      TextComponent(
        text: text,
        position: at,
        anchor: Anchor.center,
        priority: 4,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.amberAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Digital7",
          ),
        ),
        children: [
          MoveByEffect(Vector2(0, -50), EffectController(duration: 0.7, curve: Curves.easeOut)),
          RemoveEffect(delay: 0.7),
        ],
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final shaking = _shakeTime > 0 && _shakeDuration > 0;
    if (shaking) {
      final strength = _shakeIntensity * (_shakeTime / _shakeDuration);
      canvas.save();
      canvas.translate((_rng.nextDouble() * 2 - 1) * strength, (_rng.nextDouble() * 2 - 1) * strength);
    }
    super.render(canvas);
    if (shaking) canvas.restore();

    // Red flash over the screen when the player is hit.
    if (_damageFlash > 0) {
      final alpha = 0.35 * (_damageFlash / _damageFlashDuration);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), Paint()..color = Colors.red.withValues(alpha: alpha));
    }
  }

  // ---------- Pause ----------

  void pauseGame() {
    if (gameOver || paused) return;
    pauseEngine();
    overlays.remove(pauseButtonOverlay);
    overlays.add(pauseMenuOverlay);
  }

  void resumeGame() {
    overlays.remove(pauseMenuOverlay);
    if (!gameOver) overlays.add(pauseButtonOverlay);
    resumeEngine();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    // Open the pause menu when the app goes to the background, so the game
    // doesn't jump straight back into action when the player returns.
    if (state != AppLifecycleState.resumed) pauseGame();
    super.lifecycleStateChange(state);
  }
}
