import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackBar {
  static void success(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: Colors.lightGreen,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.all(10),
        borderRadius: 5,
        margin: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  static void error(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.all(10),
        borderRadius: 5,
        margin: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
