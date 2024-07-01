import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';

class DownloadSnackBar {
  static void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: primaryColor,
      content: Text(
        downloadMessage,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
