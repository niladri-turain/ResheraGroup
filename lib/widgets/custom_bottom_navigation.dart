import 'package:flutter/material.dart';


import '../core/constants/app_sizes.dart'; // 👈 add this

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    return Container(

      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D0D0D),

        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        selectedFontSize: AppSize.width(0.03),
        unselectedFontSize: AppSize.width(0.03),

        iconSize: AppSize.width(0.06),

        showUnselectedLabels: true,

        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.height(0.005),
              ),
              child: const Icon(Icons.home_filled),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.height(0.005),
              ),
              child: const Icon(Icons.description_outlined),
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.height(0.005),
              ),
              child: const Icon(Icons.grid_view_rounded),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(
                bottom: AppSize.height(0.005),
              ),
              child: const Icon(Icons.person_outline),
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}