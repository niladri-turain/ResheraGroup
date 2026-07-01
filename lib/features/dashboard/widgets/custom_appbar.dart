import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_colors.dart';
import '../../login/provider/login_provider.dart';
import '../../quickPick/provider/view_cart_list_provider.dart';

import '../../../core/constants/app_sizes.dart'; // 👈 add this

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context); // 👈 important

    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: AppSize.height(0.07), // 👈 responsive height

      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width(0.03),
        ),
        child: Row(
          children: [
            /// Profile Icon
            CircleAvatar(
              radius: AppSize.width(0.045),
              backgroundColor: AppColors.grey,
              child: Icon(
                Icons.person,
                color: AppColors.white,
                size: AppSize.width(0.05),
              ),
            ),

            SizedBox(width: AppSize.width(0.02)),

            /// Username
            Consumer<LoginProvider>(
              builder: (context, loginProvider, child) {
                return Text(
                  loginProvider.userName ?? AppStrings.guestUser,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSize.width(0.04),
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),

            const Spacer(),

            /// Logout Icon
            Consumer<LoginProvider>(
              builder: (context, loginProvider, child) {
                if (loginProvider.userName == null) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () => _handleLogout(context),
                  child: Container(
                    padding: EdgeInsets.all(
                      AppSize.width(0.02),
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout,
                      color: AppColors.white,
                      size: AppSize.width(0.05),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
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
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // 1. Capture references while context is still active
                      final loginProvider = context.read<LoginProvider>();
                      final cartProvider = context.read<ViewCartListProvider>();

                      // 2. Now it is safe to pop the dialog
                      Navigator.pop(context);

                      // 3. Perform async operations using the captured providers
                      await loginProvider.logout();
                      await cartProvider.clearCartLocal();
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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
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
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // keep default (safe)
}
