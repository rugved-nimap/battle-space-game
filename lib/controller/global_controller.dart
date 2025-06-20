import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  bool isBgOn = true;
  bool isSfxOn = true;
  late AudioPool fireSoundPool;
  late AudioPool explosionSoundPool;

  num highScore = 0;
  String userName = "";

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  void getUserDetails() async {
    userName = AppStorage.valueFor(StorageKey.userName) ?? "";
    highScore = AppStorage.valueFor(StorageKey.highScore) ?? 0;
    isBgOn = AppStorage.valueFor(StorageKey.musicSetting) ?? true;
    isSfxOn = AppStorage.valueFor(StorageKey.sfxSetting) ?? true;

    debugPrint("isBgOn ${AppStorage.valueFor(StorageKey.musicSetting)}");
    debugPrint("$isBgOn");

    initializedAudio();
  }

  void initializedAudio() async {
    FlameAudio.bgm.initialize();
    if (isBgOn) {
      await FlameAudio.bgm.play('bg_music.mp3');
    }
    fireSoundPool = await FlameAudio.createPool('fire.wav', maxPlayers: 100, minPlayers: 1);
    explosionSoundPool = await FlameAudio.createPool('explosion.mp3', maxPlayers: 100, minPlayers: 1);
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
            spacing: 25,
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
                          isBgOn ? FlameAudio.bgm.stop() : FlameAudio.bgm.play('bg_music.mp3');
                          isBgOn = !isBgOn;
                          AppStorage.setValue(StorageKey.musicSetting, isBgOn);
                          debugPrint("AppStorage.valueFor(StorageKey.musicSetting) => ${AppStorage.valueFor(StorageKey.musicSetting)}");
                          setState(() {});
                        },
                        icon: Icon(
                          isBgOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
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
                          AppStorage.setValue(StorageKey.sfxSetting, isSfxOn);
                          setState(() {});
                        },
                        icon: Icon(
                          isSfxOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
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
              ElevatedButton(
                onPressed: Get.back,
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: const WidgetStatePropertyAll(Colors.black),
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: "Digital7"),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
