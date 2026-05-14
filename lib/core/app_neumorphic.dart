import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

/// Global [NeumorphicThemeData] for Softecki FaceAccess (green on soft tinted grey).
class AppNeumorphic {
  AppNeumorphic._();

  static NeumorphicThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColor.textPrimary,
      displayColor: AppColor.textPrimary,
    );
    return NeumorphicThemeData(
      baseColor: AppColor.neumorphicBase,
      accentColor: AppColor.primaryColor,
      variantColor: Color(0xFF9BC99F),
      defaultTextColor: AppColor.textPrimary,
      depth: 5,
      intensity: 0.68,
      lightSource: LightSource.topLeft,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: AppColor.primaryColor, size: 22),
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
        depth: 4,
        color: AppColor.neumorphicBase,
      ),
    );
  }

  static NeumorphicThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    );
    return NeumorphicThemeData.dark(
      baseColor: AppColor.neumorphicBaseDark,
      accentColor: AppColor.primaryLight,
      variantColor: Color(0xFF3D5C42),
      defaultTextColor: Colors.white,
      depth: 4,
      intensity: 0.55,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: AppColor.primaryLight, size: 22),
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
        depth: 3,
        color: AppColor.neumorphicBaseDark,
      ),
    );
  }

  static NeumorphicStyle raisedSurface(BuildContext context, {double depth = 4}) {
    return NeumorphicStyle(
      depth: depth,
      color: AppColor.neumorphicSurface,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
    );
  }

  static NeumorphicStyle insetField(BuildContext context) {
    return NeumorphicStyle(
      depth: -4,
      color: NeumorphicTheme.baseColor(context),
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
    );
  }
}
