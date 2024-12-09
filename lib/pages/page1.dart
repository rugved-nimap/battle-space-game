import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_game/controller/global_controller.dart';
import 'package:flutter_game/pages/game_widget_page.dart';
import 'package:get/get.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover),
            ),
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
                      fontFamily: "Digital7",
                      letterSpacing: 5,
                      wordSpacing: 5),
                ),
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const GameWidgetPage());
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.indigo),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 60, vertical: 5))),
                  child: const Text(
                    "Play",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: "Digital7",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.settings();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.indigoAccent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 25, vertical: 5)),
                  ),
                  child: const Text(
                    "Setting",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: "Digital7",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.indigoAccent.shade100),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 4, horizontal: 25),
                    ),
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
        );
      },
    );
  }
}
