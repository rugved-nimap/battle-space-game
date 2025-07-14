import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loader {
  Loader._();

  static Loader instance = Loader._();

  bool _isLoading = false;

  void show() {
    if (_isLoading) return;
    _isLoading = true;

    Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff141D1E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CircularProgressIndicator(color: Colors.indigoAccent),
          ),
        ),
      ),
    );
  }

  void hide() {
    if (_isLoading) {
      Get.back();
      _isLoading = false;
    }
  }
}
