import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final Function(String) onSearch;

  const CustomHeaderWidget({
    super.key,
    required this.userName,
    required this.location,
    required this.onNotificationTap,
    required this.onProfileTap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context); // 👈 important

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.width(0.03),
        AppSize.height(0.02),
        AppSize.width(0.03),
        AppSize.height(0.02),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF7B2CBF),
            Color(0xFF7B2CBF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Name + Location
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.width(0.045),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSize.height(0.005)),
                  Row(
                    children: [
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppSize.width(0.032),
                        ),
                      ),
                      SizedBox(width: AppSize.width(0.01)),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: AppSize.width(0.04),
                      )
                    ],
                  )
                ],
              ),

              /// Icons
              Row(
                children: [
                  _circleIcon(
                    icon: Icons.notifications,
                    onTap: onNotificationTap,
                    showDot: true,
                  ),
                  SizedBox(width: AppSize.width(0.03)),
                  _circleIcon(
                    icon: Icons.person_outline,
                    onTap: onProfileTap,
                  ),
                ],
              )
            ],
          ),

          SizedBox(height: AppSize.height(0.02)),

          /// 🔍 Search Bar
          Container(
            height: AppSize.height(0.055),
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(0.03),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSize.width(0.06)),
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
                hintText: 'Search "desired category"',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: AppSize.width(0.032),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: AppSize.width(0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Reusable Icon Widget
  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: AppSize.width(0.10),
            width: AppSize.width(0.10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: AppSize.width(0.05),
            ),
          ),
        ),
        if (showDot)
          Positioned(
            right: AppSize.width(0.02),
            top: AppSize.width(0.02),
            child: Container(
              height: AppSize.width(0.02),
              width: AppSize.width(0.02),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
      ],
    );
  }
}