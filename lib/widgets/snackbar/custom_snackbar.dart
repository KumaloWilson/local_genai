import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void showErrorSnackbar({required String message, int? duration}) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: duration ?? 3),
    );
  }

  static void showSuccessSnackbar({required String message}) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarningSnackbar({required String message}) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber,
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfoSnackbar({required String message}) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showNeutralSnackbar({required String message}) {
    Get.snackbar(
      'Notice',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showLoadingSnackbar({required String message}) {
    Get.snackbar(
      'Loading',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueGrey,
      colorText: Colors.white,
      icon: const CircularProgressIndicator(color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: false,
      showProgressIndicator: true,
    );
  }

  static void showCustomSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition? position,
    Widget? icon,
    int? duration,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position ?? SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.purple,
      colorText: textColor ?? Colors.white,
      icon: icon,
      duration: Duration(seconds: duration ?? 3),
    );
  }
}
