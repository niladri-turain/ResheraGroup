import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/itemOrder/item_order_screen.dart';
import 'package:resheragroup/main_screen.dart';

import '../../dashboard/screen/dashboard_screen.dart';

class CustomTopNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CustomTopNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: const Color(0xFFF2F2F2),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: "Home",
                index: 0,
                onTap: () => onItemSelected(0),
              ),
              _buildNavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view,
                label: "Category",
                index: 1,
                onTap: () => onItemSelected(1),
              ),
              _buildNavItem(
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag,
                label: "Order",
                index: 2,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ItemOrderScreen()),
                  );
                },
              ),
              _buildResheraBadge(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color color =
    isSelected ? Colors.deepPurple : Colors.black87;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResheraBadge(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {  Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
            (route) => false,
      );
        // Pop until we reach the MainScreen (Dashboard)

      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7B61FF),
              Color(0xFFA855F7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Reshera",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
