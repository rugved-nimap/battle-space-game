import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/health_bar.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/flame/my_game.dart';
import 'package:flutter_game/reusable_widgets/game_over_dialog.dart';
import 'package:flutter_game/services/google_ads_service.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class UiComponent extends Component with HasGameRef {
  int score;
  double distance;
  Vector2 screenSize;

  UiComponent({
    required this.score,
    required this.distance,
    required this.screenSize,
    this.level = 1,
    this.coins = 0,
  }) : super(priority: 3);

  int level;

  /// Coins collected from enemy drops in this run.
  int coins;

  late TextComponent levelText;
  late TextComponent coinText;

  /// Where dropped coins fly to (the coin icon in the top-right corner).
  Vector2 get coinTarget => Vector2(screenSize.x - 40, 70);

  late TextComponent scoreText;
  late TextComponent distanceText;
  late FpsTextComponent fpsTextComponent;
  late TextComponent gameOverText;
  late TextComponent gameOverScoreText;
  late TextComponent gameOverDistanceText;

  // late ButtonComponent gameOverRestartButton;
  // late ButtonComponent gameOverBackButton;
  late PositionComponent healthBar;

  @override
  FutureOr<void> onLoad() async {
    scoreText = TextComponent(
      text: "Score: $score",
      position: Vector2(25, 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: "Digital7",
        ),
      ),
      priority: 3,
    );

    distanceText = TextComponent(
      text: "Distance: $distance",
      position: Vector2(25, 75),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontFamily: "Digital7",
        ),
      ),
      priority: 3,
    );

    fpsTextComponent = FpsTextComponent(
      position: Vector2(10, screenSize.y - 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontFamily: "Digital7",
        ),
      ),
    );

    gameOverText = TextComponent(
        text: "Game Over",
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        priority: 5);

    gameOverText.position = Vector2((screenSize.x / 2) - (gameOverText.width / 2), 300);

    gameOverScoreText = TextComponent(
      text: "Score: $score",
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      priority: 5,
    );

    gameOverScoreText.position = Vector2((screenSize.x / 2) - (gameOverScoreText.width / 2), gameOverText.position.y + 75);

    gameOverDistanceText = TextComponent(
      text: "Distance: $distance",
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      priority: 5,
    );
    //
    // gameOverDistanceText.position = Vector2((screenSize.x / 2) - (gameOverDistanceText.width / 2), gameOverScoreText.position.y + 40);
    //
    // final uiCancelText = buttonText("Cancel");
    // gameOverBackButton = ButtonComponent(
    //   button: RectangleComponent(
    //     size: Vector2(100, 40),
    //     paint: Paint()..color = Colors.grey.shade100.withValues(alpha: 0.5),
    //     children: [
    //       PositionComponent(
    //         position: Vector2(50 - (uiCancelText.width / 2), 20 - (uiCancelText.height / 2)),
    //         children: [uiCancelText],
    //       ),
    //     ],
    //     priority: 0,
    //   ),
    //   // buttonDown: RectangleComponent(
    //   //   size: Vector2(100, 40),
    //   //   paint: Paint()..color = Colors.grey.shade800.withOpacity(1),
    //   //   children: [
    //   //     PositionComponent(
    //   //       position: Vector2(50 - (uiCancelText.width / 2), 20 - (uiCancelText.height / 2)),
    //   //       children: [uiCancelText],
    //   //     ),
    //   //   ],
    //   // ),
    //   onPressed: () {
    //     moveToMenuPage();
    //   },
    //   size: Vector2(100, 40),
    //   priority: 5,
    // );
    //
    // final uiRestartText = buttonText("Restart");
    // gameOverRestartButton = ButtonComponent(
    //   button: RectangleComponent(
    //     size: Vector2(100, 40),
    //     paint: Paint()..color = Colors.lightGreenAccent.shade100.withValues(alpha: 0.5),
    //     children: [
    //       PositionComponent(
    //         position: Vector2(
    //           50 - (uiRestartText.width / 2),
    //           20 - (uiRestartText.height / 2),
    //         ),
    //         children: [uiRestartText],
    //       ),
    //     ],
    //   ),
    //   // buttonDown: RectangleComponent(
    //   //   size: Vector2(100, 40),
    //   //   paint: Paint()..color = Colors.lightGreenAccent.shade700.withOpacity(1),
    //   //   children: [
    //   //     PositionComponent(
    //   //       position: Vector2(50 - (uiRestartText.width / 2), 20 - (uiRestartText.height / 2)),
    //   //       children: [uiRestartText],
    //   //     ),
    //   //   ],
    //   // ),
    //   onPressed: () {
    //     restartGame();
    //   },
    //   size: Vector2(100, 40),
    //   priority: 5,
    // );
    //
    // gameOverBackButton.position = Vector2(
    //   ((screenSize.x / 2) - gameOverBackButton.width) - 20,
    //   gameOverDistanceText.position.y + 40,
    // );
    //
    // gameOverRestartButton.position = Vector2(
    //   (screenSize.x / 2) + 20,
    //   gameOverDistanceText.position.y + 40,
    // );

    healthBar = HealthBar(position: Vector2(screenSize.x - 150, 40))
      ..anchor = Anchor.topRight
      ..scale = Vector2(-1, 1);

    levelText = TextComponent(
      text: "LEVEL $level",
      position: Vector2(25, 90),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 12,
          color: Colors.amberAccent,
          fontFamily: "Digital7",
        ),
      ),
      priority: 3,
    );

    coinText = TextComponent(
      text: "$coins",
      anchor: Anchor.topRight,
      position: Vector2(screenSize.x - 46, 71),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.amber,
          fontFamily: "Digital7",
        ),
      ),
      priority: 3,
    );

    add(scoreText);
    add(distanceText);
    add(fpsTextComponent);
    add(healthBar);
    add(levelText);
    add(coinText);

    // Coin icon for the coin counter. Loaded last, so every text above is
    // ready before MyGame starts calling the update methods.
    add(
      SpriteComponent(
        sprite: await gameRef.loadSprite(AssetUtils.coin.split('/').last),
        size: Vector2.all(22),
        position: coinTarget,
        priority: 3,
      ),
    );

    return super.onLoad();
  }

  void updateScore(int newScore) {
    score = newScore;
    scoreText.text = "Score: $score";
    gameOverScoreText.text = "Score: $score";
  }

  void updateCoins(int newCoins) {
    coins = newCoins;
    coinText.text = "$coins";
  }

  /// Big "LEVEL n" banner in the middle of the screen.
  void showLevelUp(int newLevel) {
    level = newLevel;
    levelText.text = "LEVEL $level";

    final subtitle = switch (newLevel) {
      2 => "Zig-zag fighters incoming!",
      3 => "Watch out for kamikazes!",
      4 => "Heavy tanks spotted!",
      _ => "Enemies are getting faster!",
    };

    add(_bannerText("LEVEL $level", 44, screenSize.y * 0.35));
    add(_bannerText(subtitle, 16, screenSize.y * 0.35 + 40));
  }

  TextComponent _bannerText(String text, double fontSize, double y) {
    return TextComponent(
      text: text,
      anchor: Anchor.center,
      position: Vector2(screenSize.x / 2, y),
      scale: Vector2.all(0.3),
      priority: 5,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.amberAccent,
          fontWeight: FontWeight.bold,
          fontFamily: "Digital7",
          shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
        ),
      ),
      children: [
        ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.4, curve: Curves.easeOutBack)),
        RemoveEffect(delay: 1.6),
      ],
    );
  }

  void updateDistance(double newDistance) {
    distance = newDistance;
    distanceText.text = "Distance: ${distance.toStringAsFixed(2)}";
    gameOverDistanceText.text = "Distance: ${distance.toStringAsFixed(2)}";
  }

  void gameOver() {
    Get.dialog(
      barrierDismissible: false,
      GameOverDialog(
        score: score,
        distance: distance.toPrecision(2),
        onCancel: () {
          Get.back();
          Get.back();
        },
        onContinue: () async {
          await GoogleAdsService.instance.showRewardedAds(
            onUserEarnedReward: (ad, reward) {
              Get.back();
              continueGame();
            },
          );
        },
        onRestart: () {
          Get.back();
          restartGame();
        },
      ),
    );

    final num bestScore = AppStorage.valueFor(StorageKey.highScore) ?? 0;

    final controller = Get.find<GlobalController>();
    controller.userCoins += score * 5;
    AppStorage.setValue(StorageKey.userCoins, controller.userCoins);

    if (score > bestScore) {
      AppStorage.setValue(StorageKey.highScore, score);
      controller.highScore = score;
    }

    controller.updateUser(
      email: AppStorage.valueFor(StorageKey.email) ?? "",
      money: controller.userCoins.toString(),
      highScore: controller.highScore.toString(),
    );
  }

  void moveToMenuPage() {
    Get.back();
  }

  void restartGame() {
    (gameRef as MyGame).restart();
  }

  void continueGame() {
    (gameRef as MyGame).continueGame(score, distance);
  }

  TextComponent buttonText(String text) {
    return TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
