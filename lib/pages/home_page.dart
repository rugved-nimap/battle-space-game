import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/pages/game_widget_page.dart';
import 'package:flutter_game/reusable_widgets/banner_ads_widget.dart';
import 'package:flutter_game/reusable_widgets/sprite_button.dart';
import 'package:flutter_game/utils/app_storage.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Image.asset(AssetUtils.background, fit: BoxFit.cover, height: double.maxFinite, width: double.maxFinite),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      controller.userProfileDialog();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey.withValues(alpha: 0.5),
                          backgroundImage: AssetImage(controller.userAvatar),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userName,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              "HIGH SCORE: ${controller.highScore}",
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey.shade50.withValues(alpha: 0.15),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(AssetUtils.coin, scale: 22).paddingOnly(left: 4, right: 2),
                            Text(
                              "${controller.userCoins}",
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ).paddingOnly(left: 2, right: 10),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          controller.loginBottomSheet();
                        },
                        sizeStyle: CupertinoButtonSize.small,
                        padding: EdgeInsets.zero,
                        child: Image.asset(
                          AssetUtils.loginGif,
                          width: 50,
                          height: 50,
                        ),
                      )
                    ],
                  ),
                ],
              ).marginSymmetric(vertical: kToolbarHeight - 10, horizontal: 16),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Battle Space",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white,
                        letterSpacing: 5,
                        wordSpacing: 5,
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const GameWidgetPage())?.then((value) {
                          controller.update();
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.indigo),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 60, vertical: 5)),
                      ),
                      child: const Text(
                        "Play",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        controller.settings();
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.indigoAccent),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 25, vertical: 5)),
                      ),
                      child: const Text(
                        "Setting",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        exit(0);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.indigoAccent.shade100),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 4, horizontal: 25)),
                      ),
                      child: const Text(
                        "Exit",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: "Digital7",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("SELECT\nSPACECRAFT", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
              SizedBox(
                width: 75,
                height: 75,
                child: SpriteButton(
                  image: controller.playerSprite,
                  onPressed: () {
                    Get.bottomSheet(
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                              color: Colors.blueGrey.withValues(alpha: 0.25),
                            ),
                            clipBehavior: Clip.none,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  bottom: context.height * 0.48,
                                  left: context.width * 0.3,
                                  right: context.width * 0.3,
                                  child: Hero(
                                    tag: AssetUtils.playerSprite1,
                                    child: Image.asset(controller.playerSprite, width: 150, height: 150),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(
                                      "Select Spacecraft to enter the battle",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 20,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 1,
                                        ),
                                        padding: const EdgeInsets.only(top: 20),
                                        itemCount: AssetUtils.playerSpriteList.length,
                                        itemBuilder: (context, index) {
                                          final sprite = AssetUtils.playerSpriteList[index];
                                          return SpriteButton(
                                            image: sprite,
                                            isSelected: controller.playerSprite.isCaseInsensitiveContains(sprite),
                                            onPressed: () {
                                              setState(() {
                                                controller.playerSprite = sprite;
                                              });
                                              controller.update();
                                              AppStorage.setValue(StorageKey.playerSprite, sprite);
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ).paddingOnly(left: 20, right: 20, top: 50),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BannerAdsWidget(),
        );
      },
    );
  }
}
