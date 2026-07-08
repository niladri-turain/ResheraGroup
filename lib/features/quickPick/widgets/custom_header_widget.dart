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
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isTablet ? 24 : 16,
        isTablet ? 30 : 20,
        isTablet ? 24 : 16,
        isTablet ? 24 : 16,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: onLocationTap,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: isTablet ? 25 : 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isTablet ? 20 : 13,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _circleIcon(
                icon: Icons.person_outline,
                onTap: onProfileTap,
                isTablet: isTablet,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomSearchWidget(
            onSearch: onSearch,
            hintText: "Search categories...",
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
    required bool isTablet,
  }) {
    double size = isTablet ? 55 : 40;
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isTablet ? 30 : 22,
            ),
          ),
        ),
        if (showDot)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              height: 10,
              width: 10,
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
