import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  bool isBgOn = true;
  bool isSfxOn = true;
  late AudioPool fireSoundPool;
  late AudioPool explosionSoundPool;

  num highScore = 0;
  String userName = "GUEST";
  String userAvatar = AssetUtils.avatar1;
  num userCoins = 0;
  String playerSprite = AssetUtils.playerSprite1;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  @override
  void onReady() {
    super.onReady();
    if (AppStorage.valueFor(StorageKey.userName) == null) {
      userProfileDialog(showDiscardBtn: false);
    }
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  void getUserDetails() async {
    userName = AppStorage.valueFor(StorageKey.userName) ?? "GUEST";
    userAvatar = AppStorage.valueFor(StorageKey.userAvatar) ?? AssetUtils.avatar1;
    userCoins = AppStorage.valueFor(StorageKey.userCoins) ?? 0;
    highScore = AppStorage.valueFor(StorageKey.highScore) ?? 0;
    isBgOn = AppStorage.valueFor(StorageKey.musicSetting) ?? true;
    isSfxOn = AppStorage.valueFor(StorageKey.sfxSetting) ?? true;
    playerSprite = AppStorage.valueFor(StorageKey.playerSprite) ?? AssetUtils.playerSprite1;

    initializedAudio();
  }

  void initializedAudio() async {
    FlameAudio.bgm.initialize();
    if (isBgOn) {
      await FlameAudio.bgm.play(AssetUtils.bgMusic);
    }
    fireSoundPool = await FlameAudio.createPool(AssetUtils.firingSound, maxPlayers: 100, minPlayers: 1);
    explosionSoundPool = await FlameAudio.createPool(AssetUtils.explosionSound, maxPlayers: 100, minPlayers: 1);
  }

  void settings() {
    Get.defaultDialog(
      title: "Settings",
      titleStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                          isBgOn ? FlameAudio.bgm.stop() : FlameAudio.bgm.play(AssetUtils.bgMusic);
                          isBgOn = !isBgOn;
                          AppStorage.setValue(StorageKey.musicSetting, isBgOn);
                          setState(() {});
                        },
                        icon: Icon(
                          isBgOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                          color: Colors.indigoAccent,
                          size: 30,
                        ),
                      ),
                      const Text("Music", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                      const Text("SFX", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void userProfileDialog({bool showDiscardBtn = true}) {
    final TextEditingController textEditingController = TextEditingController(text: userName);
    String selected = userAvatar;

    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: const Color(0xff141D1E),
      title: "PROFILE",
      titleStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 25,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(selected),
                radius: 40,
              ),
              Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blueGrey.shade50.withValues(alpha: 0.1),
                ),
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: AssetUtils.avatarList.length,
                  itemBuilder: (context, index) {
                    final avatar = AssetUtils.avatarList[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selected = avatar;
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(AssetUtils.avatarList[index])),
                          border: selected.isCaseInsensitiveContains(avatar) ? Border.all(color: Colors.white, width: 2) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppTextField(
                controller: textEditingController,
                label: "USERNAME",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Visibility(
                    visible: showDiscardBtn,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: Get.back,
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const WidgetStatePropertyAll(Colors.redAccent),
                        ),
                        child: const Text(
                          "Discard",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (textEditingController.text.isNotEmpty) {
                          AppStorage.setValue(StorageKey.userName, textEditingController.text.trim());
                          AppStorage.setValue(StorageKey.userAvatar, selected);
                          userName = textEditingController.text;
                          userAvatar = selected;
                          update();
                          Get.back();
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
