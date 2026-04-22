import 'package:flutter/material.dart';
import 'package:resheragroup/widgets/custom_bottom_navigation.dart';

import 'features/account/screen/account_screen.dart';
import 'features/dashboard/screen/dashboard_screen.dart';
import 'features/home/screen/home_screen.dart';
import 'features/order/screen/order_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens
  final List<Widget> _pages = [
    const DashboardScreen(),
    const HomeScreen(),
    const OrderScreen(),
    const AccountScreen(),
  ];


  // Handle Back Press to Home
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: _pages[_currentIndex], // Dynamic Page
        // Reusable Bottom Navigation Call
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}