import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

import '../../../widgets/custom_search_widget.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;
  final VoidCallback? onLocationTap;
  final Function(String) onSearch;

  const CustomHeaderWidget({
    super.key,
    required this.userName,
    required this.location,
    required this.onNotificationTap,
    required this.onProfileTap,
    this.onLocationTap,
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
              Expanded(
                child: Column(
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
                    GestureDetector(
                      onTap: onLocationTap,
                      child: SizedBox(
                
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: AppSize.width(0.032),
                          ),
                          maxLines: 1,
                
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /// Icons
              Row(
                children: [
                  // _circleIcon(
                  //   icon: Icons.shopping_cart_outlined,
                  //   onTap: onNotificationTap,
                  //   showDot: true,
                  // ),
                  SizedBox(width: AppSize.width(0.03)),
                  _circleIcon(
                    icon: Icons.person_outline,
                    onTap: onProfileTap,
                  ),
                ],
              )
            ],
          ),



          /// 🔍 Search Bar
          // CustomSearchWidget(onSearch: onSearch),
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