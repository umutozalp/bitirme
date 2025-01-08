import 'package:bitirme/core/app_color.dart';
import 'package:flutter/material.dart' show Color, Colors;

class RecommendedProduct {
  Color? cardBackgroundColor;
  Color? buttonTextColor;
  Color? buttonBackgroundColor;
  String imagePath;

  RecommendedProduct({
    this.cardBackgroundColor,
    this.buttonTextColor = AppColor.darkGreen,
    this.buttonBackgroundColor = Colors.white,
    this.imagePath = "assets/images/shopping.png",
  });
}
