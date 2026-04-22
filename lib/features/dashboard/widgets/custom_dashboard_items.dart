import 'package:flutter/material.dart';
import 'package:resheragroup/features/dashboard/widgets/animated_image.dart';

import '../../../core/constants/app_sizes.dart';

class DashboardItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback? onTap;

  const DashboardItem({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          /// Icon Box
          Container(
            height: AppSize.width(0.16), // 👈 responsive square
            width: AppSize.width(0.16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(
                AppSize.width(0.03),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.6),
                  blurRadius: AppSize.width(0.03),
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: Colors.orange,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                AppSize.width(0.03), // 👈 responsive padding
              ),
              child: AnimatedIconImage(
                imagePath: imagePath,
              ),
            ),
          ),

          SizedBox(height: AppSize.height(0.008)),

          /// Title
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2, // 👈 important (overflow fix)
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSize.width(0.03), // 👈 responsive text
            ),
          ),
        ],
      ),
    );
  }
}