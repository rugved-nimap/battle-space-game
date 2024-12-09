import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {

  bool isBgOn = true;
  bool isSfxOn = true;
  late AudioPool fireSoundPool;
  late AudioPool explosionSoundPool;

  @override
  void onInit() {
    initializedAudio();
    super.onInit();
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  void initializedAudio() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('bg_music.mp3');
    isBgOn = FlameAudio.bgm.isPlaying;

    fireSoundPool = await FlameAudio.createPool('fire.wav',
        maxPlayers: 100, minPlayers: 1);
    explosionSoundPool = await FlameAudio.createPool('explosion.mp3',
        maxPlayers: 100, minPlayers: 1);
  }

  void settings() {
    Get.defaultDialog(
      title: "Settings",
      titleStyle: const TextStyle(
        fontFamily: "Digital7",
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          isBgOn
                              ? FlameAudio.bgm.stop()
                              : FlameAudio.bgm.play('bg_music.mp3');
                          isBgOn = !isBgOn;
                          setState(() {});
                        },
                        icon: Icon(
                          isBgOn
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: Colors.indigoAccent,
                          size: 30,
                        ),
                      ),
                      const Text(
                        "Music",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Digital7",
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          isSfxOn = !isSfxOn;
                          // isBgOn
                          //     ? FlameAudio.bgm.stop()
                          //     : FlameAudio.bgm
                          //     .play('bg_music', volume: bgmusic_volume);
                          setState(() {});
                        },
                        icon: Icon(
                          isSfxOn
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: Colors.indigoAccent,
                          size: 30,
                        ),
                      ),
                      const Text(
                        "SFX",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Digital7",
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(Colors.black),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: "Digital7",
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
