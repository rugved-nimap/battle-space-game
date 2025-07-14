import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/reusable_widgets/app_snack_bar.dart';
import 'package:flutter_game/reusable_widgets/app_text_field.dart';
import 'package:flutter_game/reusable_widgets/loader.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  final repository = AppRepository();

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

  void loginBottomSheet() async {
    final TextEditingController emailTextController = TextEditingController();
    final TextEditingController passTextController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();

    await Get.bottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: const Color(0xff141D1E),
      clipBehavior: Clip.hardEdge,
      Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueGrey.shade800),
              ),
              const Text(
                "LOGIN",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
              ),
              AppTextField(
                controller: emailTextController,
                label: "EMAIL",
                validator: (v) {
                  if (v == null || !v.isEmail) return "Please enter email";
                  return null;
                },
              ),
              AppTextField(
                controller: passTextController,
                label: "PASSWORD",
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Please enter password";
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? (emailTextController.text.isEmail || passTextController.text.isNotEmpty)) {
                    loginApi(emailTextController.text, passTextController.text);
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                  fixedSize: const WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),
                ),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ).paddingAll(16),
    );
  }

  Future<void> loginApi(String email, pass) async {
    if (Get.context != null) FocusScope.of(Get.context!).unfocus();

    Loader.instance.show();
    try {
      dynamic body = {"email": email, "password": pass};
      final result = await repository.login(body);
      if (result != null) {
        dynamic userData = result['user'];
        dynamic token = result['token'];
        AppStorage.setValue(StorageKey.accessToken, token);

        AppStorage.setValue(StorageKey.userId, userData['_id']);
        AppStorage.setValue(StorageKey.userName, userData['username']);
        AppStorage.setValue(StorageKey.userCoins, userData['money']);
        AppStorage.setValue(StorageKey.highScore, userData['highScore']);

        getUserDetails();
        Loader.instance.hide();
        Get.back();
        AppSnackBar.success("Login Successfully");
      }
    } catch (e) {
      Loader.instance.hide();
      debugPrint("Error while login: $e");
    }
  }
}
