
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../flame/my_game.dart';

class GameWidgetPage extends StatelessWidget {
  const GameWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GameWidget(
        game: MyGame(context: context),
      ),
    );
  }
}
