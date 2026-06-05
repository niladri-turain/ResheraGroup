import 'package:flutter/material.dart';
import '../core/constants/app_sizes.dart';

class CustomSearchWidget extends StatelessWidget {
  final Function(String) onSearch;
  final String hintText;
  final double? height;

  const CustomSearchWidget({
    super.key,
    required this.onSearch,
    this.hintText = 'Search "desired category"',
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Container(
      height: height ?? AppSize.height(0.055),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(0.03),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.width(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        onChanged: onSearch,
        style: TextStyle(
          fontSize: AppSize.width(0.035),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: AppSize.width(0.032),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: AppSize.width(0.05),
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
