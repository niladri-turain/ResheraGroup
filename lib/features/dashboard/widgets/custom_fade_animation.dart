
import 'package:flutter/material.dart';


import '../../../core/constants/app_sizes.dart';
import 'animated_image.dart';

class CustomFadeAnimatedDashboardCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color themeColor;

  const CustomFadeAnimatedDashboardCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.themeColor,
  });

  @override
  State<CustomFadeAnimatedDashboardCard> createState() => _CustomFadeAnimatedDashboardCardState();
}

class _CustomFadeAnimatedDashboardCardState extends State<CustomFadeAnimatedDashboardCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    return Stack(
      alignment: Alignment.center,
      children: [

        /// 1. Background
        Container(
          width: AppSize.width(0.40),
          height: AppSize.height(0.22),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1212),
            borderRadius: BorderRadius.circular(
              AppSize.width(0.03),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppSize.width(0.03),
            ),
            child: Stack(
              children: [

                RotationTransition(
                  turns: _controller,
                  child: const Center(), // (empty but kept for structure)
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.themeColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        widget.themeColor.withOpacity(0.2),
                        widget.themeColor.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 2. Content
        SizedBox(
          width: AppSize.width(0.39),
          height: AppSize.height(0.21),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.height(0.015),
              horizontal: AppSize.width(0.025),
            ),
            child: Column(
              children: [

                Expanded(
                  flex: 3,
                  child: AnimatedIconImage(
                    imagePath: widget.imagePath,
                  ),
                ),

                SizedBox(height: AppSize.height(0.01)),

                Flexible(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(0.04),
                        vertical: AppSize.height(0.008),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          AppSize.width(0.03),
                        ),
                        border: Border.all(
                          color: widget.themeColor.withOpacity(0.5),
                          width: 0.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.orange,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        widget.title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSize.width(0.03), // 👈 responsive text
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}