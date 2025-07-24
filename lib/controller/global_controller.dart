import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/network/api_client.dart';
import 'package:flutter_game/repository/app_repository.dart';
import 'package:flutter_game/reusable_widgets/add_user_bottom_sheet.dart';
import 'package:flutter_game/reusable_widgets/app_snack_bar.dart';
import 'package:flutter_game/reusable_widgets/loader.dart';
import 'package:flutter_game/reusable_widgets/login_bottom_sheet.dart';
import 'package:flutter_game/reusable_widgets/sign_up_bottom_sheet.dart';
import 'package:flutter_game/reusable_widgets/user_profile_dialog.dart';
import 'package:flutter_game/services/google_ads_service.dart';
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
  String? userId;
  String userName = "GUEST";
  String userAvatar = AssetUtils.avatar1;
  num userCoins = 0;
  String playerSprite = AssetUtils.playerSprite1;

  late Timer timer;
  bool showAds = false;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
    // timer = Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     print("ModalRoute.of(Get.context!)?.settings.name => ${Get.context} ${ModalRoute.of(Get.context!)?.settings.name}");
    //     // if (Get.context != null) {
    //     //   if ("/HomePage" == ModalRoute.of(Get.context!)?.settings.name) {
    //     //     GoogleAdsService.instance.rewardedAds(onUserEarnedReward: (ad, reward) {});
    //     //   }
    //     // } else {
    //     //   showAds = true;
    //     // }
    //   },
    // );
  }

  @override
  void onReady() {
    super.onReady();
    if (AppStorage.valueFor(StorageKey.accessToken) == null && AppStorage.valueFor(StorageKey.userName) == null) {
      signUpBottomSheet().then((value) {
        if (value == null) {
          userProfileDialog(showDiscardBtn: false);
        }
      });
    } else {
      GoogleAdsService.instance.onAppOpenAds();
    }
  }

  @override
  void dispose() {
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  void getUserDetails() async {
    userId = AppStorage.valueFor(StorageKey.userId);
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
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: const Color(0xff141D1E),
      title: "PROFILE",
      titleStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      content: UserProfileDialog(
        userName: userName,
        userAvatar: userAvatar,
        showDiscardBtn: showDiscardBtn,
      ),
    ).then((value) {
      if (value != null) {
        AppStorage.setValue(StorageKey.userName, value['userName']);
        AppStorage.setValue(StorageKey.userAvatar, value['userAvatar']);
        userName = value['userName'];
        userAvatar = value['userAvatar'];
        String email = AppStorage.valueFor(StorageKey.email) ?? '';
        update();
        updateUser(email: email, username: userName);
      }
    });
  }

  Future<dynamic> signUpBottomSheet() async {
    final result = await Get.bottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: const Color(0xff141D1E),
      clipBehavior: Clip.hardEdge,
      SignUpBottomSheet(
        register: signUp,
        verifyOtp: verifyOtp,
      ),
    );

    if (result != null) {
      addUserBottomSheet(result);
      return result;
    }
  }

  void loginBottomSheet() async {
    await Get.bottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: const Color(0xff141D1E),
      clipBehavior: Clip.hardEdge,
      LoginBottomSheet(
        onSignUpTap: () {
          signUpBottomSheet();
        },
      ),
    ).then((value) {
      if (value != null) {
        loginApi(value['email'], value['password']);
      }
    });
  }

  void addUserBottomSheet(String email) async {
    await Get.bottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: const Color(0xff141D1E),
      clipBehavior: Clip.hardEdge,
      AddUserBottomSheet(
        email: email,
        addUserApi: addUser,
      ),
    );
  }

  Future<void> loginApi(String email, pass) async {
    Loader.instance.show();
    try {
      dynamic body = {"email": email, "password": pass};
      final result = await repository.login(body);
      if (result != null) {
        dynamic userData = result['user'];
        dynamic token = result['token'];

        AppStorage.setValue(StorageKey.accessToken, token);
        ApiClient.instance.addHeaderToDio();

        AppStorage.setValue(StorageKey.email, userData['email']);
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
      AppSnackBar.error("$e");
      debugPrint("Error while login: $e");
    }
  }

  Future<void> signUp(String email) async {
    try {
      dynamic body = {"email": email};
      final result = await repository.register(body);
      if (result != null) {
        AppSnackBar.success("${result['message']}");
      }
    } catch (e) {
      AppSnackBar.error("$e");
      debugPrint("Error in sign up: $e");
    }
  }

  Future<void> verifyOtp(String email, otp) async {
    try {
      dynamic body = {"email": email, "otp": otp};
      final result = await repository.verifyOtp(body);
      if (result != null) {
        Get.back(result: email);
        AppSnackBar.success("${result['message']}");

        dynamic token = result['token'];

        AppStorage.setValue(StorageKey.accessToken, token);
        ApiClient.instance.addHeaderToDio();
      }
    } catch (e) {
      AppSnackBar.error("$e");
      debugPrint("Error in sign up: $e");
    }
  }

  Future<void> addUser(String email, password, username) async {
    Loader.instance.show();
    try {
      dynamic body = {
        "email": email,
        "password": password,
        "username": username,
      };
      final result = await repository.addUser(body);
      if (result != null) {
        AppSnackBar.success("${result['message']}");
      }
    } catch (e) {
      Loader.instance.hide();
      AppSnackBar.error("$e");
      debugPrint("Error in sign up: $e");
    }
  }

  Future<void> updateUser({required String email, String? username, String? money, String? highScore}) async {
    try {
      dynamic body = {
        "email": email,
        if (username != null) "username": username,
        if (money != null) "money": money,
        if (highScore != null) "highScore": highScore,
      };
      await repository.updateUser(body);
    } catch (e) {
      debugPrint("Error in sign up: $e");
    }
  }

  Future<dynamic> getRank(String score) async {
    try {
      final result = await repository.getRank(userId, score);
      return result;
    } catch (e) {
      debugPrint("Error in getting rank: $e");
    }
  }
}
