import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../../../core/app_color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = AppColor.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: NeumorphicButton(
        onPressed: enabled ? onPressed : null,
        style: NeumorphicStyle(
          color: color,
          depth: enabled ? 6 : 1,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(borderRadius),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: textColor,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
