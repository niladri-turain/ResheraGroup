import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSize.height(0.18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.width(0.04)),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.width(0.04)),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(AppSize.width(0.03)),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSize.width(0.04),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}