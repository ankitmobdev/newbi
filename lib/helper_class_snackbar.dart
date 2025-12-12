import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../main.dart'; // import your MyApp file

class AppSnackBar {
  /// Show a custom snackbar (you can use this internally)
  static void show(String message, {Color? backgroundColor}) {
    MyApp.messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// ✅ Success snackbar (green)
  static void success(String message) {
    show(message, backgroundColor: Colors.black87);
  }

  /// ❌ Error snackbar (red)
  static void error(String message) {
    show(message, backgroundColor: Colors.black87);
  }

  static void error1(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /*================ for navigation ================*/
  static Future<void> moveToScreenwithPush(
      BuildContext context, dynamic nextscreen) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithPushreplaceemt(
      BuildContext context, dynamic nextscreen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithRoutClear(BuildContext context, Widget Function() nextScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => nextScreen()),
          (Route<dynamic> route) => false,
    );
  }


  static popScreen(BuildContext context) {
    Navigator.pop(context);
  }
}
