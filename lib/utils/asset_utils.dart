class AssetUtils {
  static String background = "assets/images/background.jpg";

  // Coin
  static String coin = "assets/images/coin_sprite.png";

  // Health Bar
  static String health = "assets/images/heart.png";

  // Helper Spacecraft
  static String helperSpacecraft = "assets/images/helper_spacecraft.png";

  // Avatar
  static String playerSprite1 = "assets/images/player_spaceship_sprite/player_sprite1.png";
  static String playerSprite2 = "assets/images/player_spaceship_sprite/player_sprite2.png";
  static String playerSprite3 = "assets/images/player_spaceship_sprite/player_sprite3.png";
  static String playerSprite4 = "assets/images/player_spaceship_sprite/player_sprite4.png";

  // Player Sprite
  static String avatar1 = "assets/images/avatar/avatar1.jpg";
  static String avatar2 = "assets/images/avatar/avatar2.jpg";
  static String avatar3 = "assets/images/avatar/avatar3.jpg";
  static String avatar4 = "assets/images/avatar/avatar4.jpg";
  static String avatar5 = "assets/images/avatar/avatar5.jpg";
  static String avatar6 = "assets/images/avatar/avatar6.jpg";

  // Explosion
  static String explosion0 = "explosions/0.png";
  static String explosion1 = "explosions/1.png";
  static String explosion2 = "explosions/2.png";
  static String explosion3 = "explosions/3.png";
  static String explosion4 = "explosions/4.png";
  static String explosion5 = "explosions/5.png";

  // Enemy Sprite
  static String enemySprite1 = "assets/images/enemy_spaceship_sprite/enemy1.png";
  static String enemySprite2 = "assets/images/enemy_spaceship_sprite/enemy2.png";
  static String enemySprite3 = "assets/images/enemy_spaceship_sprite/enemy3.png";

  // Sounds
  static String bgMusic = "bg_music.mp3";
  static String explosionSound = "explosion.mp3";
  static String firingSound = "fire.wav";

  // GIF
  static String loginGif = "assets/gif/login.gif";
  static String signUpGif = "assets/gif/signup.gif";


  static List<String> avatarList = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
    avatar6,
  ];

  static List<String> playerSpriteList = [
    playerSprite1,
    playerSprite2,
    playerSprite3,
    playerSprite4,
  ];

  static List<String> enemySpriteList = [
    enemySprite1,
    enemySprite2,
    enemySprite3,
  ];

  static List<String> explosionSpriteList = [
    explosion0,
    explosion1,
    explosion2,
    explosion3,
    explosion4,
    explosion5,
  ];

  static String getLastTwoElementOfString(String path) {
    final list = path.split('/');
    final length = list.length;

    return "${list[length - 2]}/${list[length - 1]}";
  }
}
