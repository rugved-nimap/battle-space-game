import 'package:flutter/painting.dart';

/// The different kinds of enemies. Stronger types unlock as the level rises
/// (see `MyGame.pickEnemyType`).
enum EnemyType {
  /// The original enemy: flies straight down and shoots.
  basic(maxHits: 5, points: 1, coins: 1, size: 70, canShoot: true, tint: null),

  /// Weaves left and right while coming down.
  zigzag(maxHits: 4, points: 2, coins: 2, size: 65, canShoot: true, tint: Color(0x5500E5FF)),

  /// Fast, doesn't shoot, steers towards the player. Crashing into it ends the game.
  kamikaze(maxHits: 2, points: 2, coins: 2, size: 60, canShoot: false, tint: Color(0x66FF1744)),

  /// Big and slow, takes many hits and fires two bullets at once.
  tank(maxHits: 12, points: 5, coins: 5, size: 100, canShoot: true, tint: Color(0x55B388FF));

  const EnemyType({
    required this.maxHits,
    required this.points,
    required this.coins,
    required this.size,
    required this.canShoot,
    required this.tint,
  });

  /// Bullets needed to destroy it.
  final int maxHits;

  /// Score added when destroyed.
  final int points;

  /// Coins dropped when destroyed.
  final int coins;

  /// Width and height in pixels.
  final double size;

  final bool canShoot;

  /// Colour laid over the sprite so each type is easy to recognise.
  final Color? tint;
}
