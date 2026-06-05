import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class CustomLoginTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const CustomLoginTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background for input to match the login card
        borderRadius: BorderRadius.circular(AppSize.width(0.03)),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppSize.width(0.04),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white38,
            fontSize: AppSize.width(0.038),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.width(0.04),
            vertical: AppSize.height(0.018),
          ),
        ),
      ),
    );
  }
}
