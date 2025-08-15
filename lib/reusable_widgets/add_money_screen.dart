import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/utils/asset_utils.dart';
import 'package:get/get.dart';

class AddMoneyScreen extends StatelessWidget {
  const AddMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              Image.asset(
                AssetUtils.background,
                fit: BoxFit.cover,
                height: double.maxFinite,
                width: double.maxFinite,
              ),
              Positioned(
                left: 20,
                top: 40,
                child: CupertinoButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetUtils.coin,
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                    ),
                    const Text(
                      "Coins",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${controller.userCoins}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      "BUY MORE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "Watch Ads",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "100 COINS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "500 COINS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "1000 COINS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "2000 COINS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blueGrey.shade900.withValues(alpha: 0.7),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {

                            },
                            splashColor: Colors.blueGrey.shade900,
                            highlightColor: Colors.blueGrey.shade900,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  AssetUtils.coin,
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  "2500 COINS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
