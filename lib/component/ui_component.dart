import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/component/health_bar.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/flame/my_game.dart';
import 'package:flutter_game/reusable_widgets/game_over_dialog.dart';
import 'package:flutter_game/services/google_ads_service.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:get/get.dart';

class UiComponent extends Component with HasGameRef {
  int score;
  double distance;
  Vector2 screenSize;

  UiComponent({
    required this.score,
    required this.distance,
    required this.screenSize,
  }) : super(priority: 3);

  late TextComponent scoreText;
  late TextComponent distanceText;
  late FpsTextComponent fpsTextComponent;
  late TextComponent gameOverText;
  late TextComponent gameOverScoreText;
  late TextComponent gameOverDistanceText;
  late ButtonComponent gameOverRestartButton;
  late ButtonComponent gameOverBackButton;
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

    gameOverDistanceText.position = Vector2((screenSize.x / 2) - (gameOverDistanceText.width / 2), gameOverScoreText.position.y + 40);

    final uiCancelText = buttonText("Cancel");
    gameOverBackButton = ButtonComponent(
      button: RectangleComponent(
        size: Vector2(100, 40),
        paint: Paint()..color = Colors.grey.shade100.withValues(alpha: 0.5),
        children: [
          PositionComponent(
            position: Vector2(50 - (uiCancelText.width / 2), 20 - (uiCancelText.height / 2)),
            children: [uiCancelText],
          ),
        ],
        priority: 0,
      ),
      // buttonDown: RectangleComponent(
      //   size: Vector2(100, 40),
      //   paint: Paint()..color = Colors.grey.shade800.withOpacity(1),
      //   children: [
      //     PositionComponent(
      //       position: Vector2(50 - (uiCancelText.width / 2), 20 - (uiCancelText.height / 2)),
      //       children: [uiCancelText],
      //     ),
      //   ],
      // ),
      onPressed: () {
        moveToMenuPage();
      },
      size: Vector2(100, 40),
      priority: 5,
    );

    final uiRestartText = buttonText("Restart");
    gameOverRestartButton = ButtonComponent(
      button: RectangleComponent(
        size: Vector2(100, 40),
        paint: Paint()..color = Colors.lightGreenAccent.shade100.withValues(alpha: 0.5),
        children: [
          PositionComponent(
            position: Vector2(
              50 - (uiRestartText.width / 2),
              20 - (uiRestartText.height / 2),
            ),
            children: [uiRestartText],
          ),
        ],
      ),
      // buttonDown: RectangleComponent(
      //   size: Vector2(100, 40),
      //   paint: Paint()..color = Colors.lightGreenAccent.shade700.withOpacity(1),
      //   children: [
      //     PositionComponent(
      //       position: Vector2(50 - (uiRestartText.width / 2), 20 - (uiRestartText.height / 2)),
      //       children: [uiRestartText],
      //     ),
      //   ],
      // ),
      onPressed: () {
        restartGame();
      },
      size: Vector2(100, 40),
      priority: 5,
    );

    gameOverBackButton.position = Vector2(
      ((screenSize.x / 2) - gameOverBackButton.width) - 20,
      gameOverDistanceText.position.y + 40,
    );

    gameOverRestartButton.position = Vector2(
      (screenSize.x / 2) + 20,
      gameOverDistanceText.position.y + 40,
    );

    healthBar = HealthBar(position: Vector2(screenSize.x - 150, 40))
      ..anchor = Anchor.topRight
      ..scale = Vector2(-1, 1);

    add(scoreText);
    add(distanceText);
    add(fpsTextComponent);
    add(healthBar);

    return super.onLoad();
  }

  void updateScore(int newScore) {
    score = newScore;
    scoreText.text = "Score: $score";
    gameOverScoreText.text = "Score: $score";
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
          await GoogleAdsService.instance.rewardedAds(
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

    // add(gameOverText);
    // add(gameOverScoreText);
    // add(gameOverDistanceText);
    // add(gameOverBackButton);
    // add(gameOverRestartButton);

    final num bestScore = AppStorage.valueFor(StorageKey.highScore) ?? 0;

    final controller = Get.find<GlobalController>();
    controller.userCoins += score * 5;
    AppStorage.setValue(StorageKey.userCoins, controller.userCoins);

    if (score > bestScore) {
      AppStorage.setValue(StorageKey.highScore, score);
      controller.highScore = score;
      // controller.update();
    }
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
