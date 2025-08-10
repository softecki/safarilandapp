import 'package:flutter/material.dart';

import '../../../core/app_color.dart';

import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType; // 👈 Add this

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.keyboardType = TextInputType.text, // 👈 Default value
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // return TextField(
    //   controller: widget.controller,
    //   obscureText: widget.isPassword ? _obscureText : false,
    //   keyboardType: widget.keyboardType, // 👈 Use the keyboardType
    //   inputFormatters: widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone
    //       ? [FilteringTextInputFormatter.digitsOnly]
    //       : null, // 👈 Restrict to digits if numeric
    //
    //   decoration: InputDecoration(
    //     hintText: widget.hintText,
    //     prefixIcon: Icon(widget.icon, color: Colors.blueGrey),
    //     suffixIcon: widget.isPassword
    //         ? IconButton(
    //       icon: Icon(
    //         _obscureText ? Icons.visibility_off : Icons.visibility,
    //         color: Colors.blueGrey,
    //       ),
    //       onPressed: () {
    //         setState(() {
    //           _obscureText = !_obscureText;
    //         });
    //       },
    //     )
    //         : null,
    //     filled: true,
    //     fillColor: Colors.blue.shade50,
    //     contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.blueGrey),
    //     ),
    //     enabledBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
    //     ),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
    //     ),
    //   ),
    // );
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.keyboardType == TextInputType.number || widget.keyboardType == TextInputType.phone
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(widget.icon, color: Colors.blueGrey),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.blueGrey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );

  }
}
