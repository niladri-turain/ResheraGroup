import 'package:flutter/material.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_colors.dart';


import '../../../core/constants/app_sizes.dart'; // 👈 add this

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
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
            Text(
              AppStrings.guestUser,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSize.width(0.04),
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            /// Notification Icon
            Stack(
              clipBehavior: Clip.none,
              children: [

                Container(
                  padding: EdgeInsets.all(
                    AppSize.width(0.02),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.white,
                    size: AppSize.width(0.05),
                  ),
                ),

                /// Badge
                Positioned(
                  right: -AppSize.width(0.01),
                  top: -AppSize.height(0.005),
                  child: Container(
                    height: AppSize.width(0.04),
                    width: AppSize.width(0.04),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.width(0.025),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // keep default (safe)
}