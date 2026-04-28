import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/app_sizes.dart';

class CustomSkeletonWidget extends StatelessWidget {
  const CustomSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure AppSize is initialized if not already
    AppSize.init(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1500), // Smoother animation
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: AppSize.height(0.02)),
          itemCount: 8,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(0.04),
              vertical: AppSize.height(0.015),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSize.width(0.22),
                  height: AppSize.width(0.22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: AppSize.width(0.04)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: AppSize.height(0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.015)),
                      Container(
                        width: AppSize.width(0.5),
                        height: AppSize.height(0.018),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.015)),
                      Container(
                        width: AppSize.width(0.3),
                        height: AppSize.height(0.018),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
