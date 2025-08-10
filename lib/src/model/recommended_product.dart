import 'package:wicom/core/app_color.dart';
import 'package:flutter/material.dart' show Color, Colors;

import '../../generated/assets.dart';

class RecommendedProduct {
  Color? cardBackgroundColor;
  Color? buttonTextColor;
  Color? buttonBackgroundColor;
  String imagePath;

  RecommendedProduct({
    this.cardBackgroundColor,
    this.buttonTextColor = AppColor.darkOrange,
  this.buttonBackgroundColor =  AppColor.primaryColor,
    this.imagePath = Assets.imagesNalopa,
  });
}
