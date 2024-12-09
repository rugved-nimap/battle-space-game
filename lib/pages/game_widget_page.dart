import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:get/get.dart';

import '../flame/my_game.dart';

class GameWidgetPage extends StatelessWidget {
  const GameWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (controller) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: GameWidget(
            game: MyGame(controller: controller),
          ),
        );
      },
    );
  }
}
