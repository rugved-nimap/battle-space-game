import 'package:flutter/material.dart';
import 'package:flutter_game/flame/my_game.dart';
import 'package:flutter_game/reusable_widgets/control_settings.dart';
import 'package:get/get.dart';

/// Small pause button shown at the top of the screen while playing.
class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.game});

  final MyGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Material(
            color: Colors.black38,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: IconButton(
              onPressed: game.pauseGame,
              iconSize: 28,
              icon: const Icon(Icons.pause_rounded, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-screen pause menu: resume, restart, quit, sound and control settings.
class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key, required this.game});

  final MyGame game;

  Widget _button(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
      ),
    ).marginOnly(bottom: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xff141D1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.6)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "PAUSED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Digital7",
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                _button("Resume", Colors.indigo, game.resumeGame),
                _button("Restart", Colors.indigoAccent, () {
                  game.resumeGame();
                  game.restart();
                }),
                _button("Quit", Colors.blueGrey, () => Get.back()),
                const Divider(color: Colors.white24, height: 24),
                const ControlSettings(textColor: Colors.white, showSound: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
