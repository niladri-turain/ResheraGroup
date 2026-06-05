import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_images_png.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../../login/provider/login_provider.dart';
import '../../quickPick/provider/view_cart_list_provider.dart';
import '../../login/screen/login_screen.dart';

class AccountScreenMobile extends StatefulWidget {
  const AccountScreenMobile({super.key});

  @override
  State<AccountScreenMobile> createState() => _AccountScreenMobileState();
}

class _AccountScreenMobileState extends State<AccountScreenMobile> {
  final SharedPrefService _prefService = sl<SharedPrefService>();
  
  String? name;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final n = await _prefService.getName();
    final un = await _prefService.getUsername();
    final id = await _prefService.getUserId();
    if (mounted) {
      setState(() {
        name = n;
        username = un;
        // Optionally store the int ID if needed elsewhere
      });
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Log Out?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            "Are you sure want to log out?",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await context.read<LoginProvider>().logout();
                      if (mounted) {
                        await context.read<ViewCartListProvider>().clearCartLocal();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2CBF),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        if (loginProvider.userName == null) {
          return const LoginScreen();
        }

        return Scaffold(
          body: Stack(
            children: [
              // 1. Background Image
              Positioned.fill(
                child: Image.asset(
                  AppImagesPng.dashboardBackground,
                  fit: BoxFit.cover,
                ),
              ),
              
              // 2. Dark Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.85),
                ),
              ),

              // 3. Content
              SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(0.05),
                        vertical: AppSize.height(0.02),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: AppSize.width(0.07),
                            backgroundColor: Colors.grey[700],
                            child: Icon(Icons.person, size: AppSize.width(0.08), color: Colors.white70),
                          ),
                          SizedBox(width: AppSize.width(0.04)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name ?? loginProvider.userName ?? "User Name",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSize.width(0.045),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  username ?? "ID: 000000",
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontSize: AppSize.width(0.03),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 1),
                            ),
                            child: IconButton(
                              onPressed: _handleLogout,
                              icon: const Icon(Icons.lock_outline, color: Colors.orange, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: Colors.white10, height: 1),

                    // Menu List
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.02)),
                        children: [
                          _buildMenuItem(Icons.home_outlined, "Home", onTap: () {}),
                          _buildMenuItem(Icons.dashboard_customize_outlined, "My Dashboard", onTap: () {}),
                          _buildMenuItem(Icons.person_outline, "My Profile", onTap: () {}),
                          // _buildMenuItem(Icons.verified_user_outlined, "Member Registration", onTap: () {}),
                          // _buildMenuItem(Icons.account_balance_wallet_outlined, "Deposit", onTap: () {}),
                          // _buildMenuItem(Icons.confirmation_number_outlined, "Ticket", onTap: () {}),
                          // _buildMenuItem(Icons.directions_car_outlined, "My Dream Car", onTap: () {}),
                          // _buildMenuItem(Icons.storefront_outlined, "My Network", hasDropdown: true),
                          // _buildMenuItem(Icons.description_outlined, "BA BV Report", onTap: () {}),
                          // _buildMenuItem(Icons.person_add_alt_1_outlined, "Franchisee Registration", onTap: () {}),
                          // _buildMenuItem(Icons.track_changes_outlined, "Commissions", hasDropdown: true),
                          // _buildMenuItem(Icons.lightbulb_outline, "Lead Generation", onTap: () {}),
                          // _buildMenuItem(Icons.favorite_border, "Wish Request", onTap: () {}),
                          _buildMenuItem(Icons.lock_open_outlined, "Logout", onTap: _handleLogout),
                          SizedBox(height: AppSize.height(0.05)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap, bool hasDropdown = false}) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(

        leading: Icon(icon, color: Colors.white60, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: hasDropdown ? const Icon(Icons.keyboard_arrow_down, color: Colors.white30, size: 18) : null,
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
      ),
    );
  }
}
