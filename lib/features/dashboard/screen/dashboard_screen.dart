import 'package:flutter/material.dart';

import 'package:resheragroup/core/constants/app_images_png.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_webp.dart';

import 'package:resheragroup/features/dashboard/widgets/reusable_slider.dart';
import 'package:resheragroup/features/quickPick/screen/quick_pick_screen.dart';

import '../../../core/constants/app_sizes.dart';

import '../../../widgets/custom_pop_up.dart';
import '../widgets/custom_animated_dashboard_card.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_dashboard_items.dart';
import '../widgets/custom_fade_animation.dart';
import '../widgets/custom_gradient_border.dart';
import '../widgets/rotation_animation_component.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    AppSize.init(context); // 👈 IMPORTANT

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImagesPng.dashboardBackground,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.02)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesPng.slide1,
                    AppImagesPng.slide2,
                    AppImagesPng.slide3,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSize.width(0.02)),
                    child: const GradientBorderText(text: AppStrings.company),
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    childAspectRatio: 0.8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DashboardItem(
                          imagePath: AppImagesPng.company_profile,
                          title: "Company\nProfile",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.management,
                          title: "Management",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.event,
                          title: "Events",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.reshera_group,
                          title: "Why Reshera",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.our_band,
                          title: "Our Brand",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.certificate,
                          title: "Our\nCertificate",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.business,
                          title: "Business Opportunity",
                          onTap: () {}),
                      DashboardItem(
                          imagePath: AppImagesPng.view_more,
                          title: "View More",
                          onTap: () {}),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesPng.slide5,
                    AppImagesPng.slide4,
                    AppImagesPng.slide1,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: AppSize.height(0.02),
                    crossAxisSpacing: AppSize.width(0.02),
                    children: [
                      const CustomAnimatedDashboardCard(
                        title: "TOHFA",
                        imagePath: AppImagesWebp.tohfa,
                        themeColor: Colors.orange,

                      ),
                      const CustomAnimatedDashboardCard(
                          title: "MAGIC TOUCH",
                          imagePath: AppImagesWebp.magic,
                          themeColor: Colors.green),
                      CustomAnimatedDashboardCard(
                          title: "QUICK PICK",
                          imagePath: AppImagesWebp.food,
                          themeColor: const Color(0XFFc164de),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const QuickPickScreen()),
                          );
                        },),
                      const CustomAnimatedDashboardCard(
                          title: "HEAL AAJ",
                          imagePath: AppImagesWebp.heal,
                          themeColor: Color(0XFFeb6250)),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesPng.slide5,
                    AppImagesPng.slide4,
                    AppImagesPng.slide1,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: AppSize.height(0.02),
                    crossAxisSpacing: AppSize.width(0.02),
                    children: const [
                      CustomRotationAnimation(
                          title: "ROOM QUICK",
                          imagePath: AppImagesWebp.quickRoom,
                          themeColor: Colors.blue),
                      CustomRotationAnimation(
                          title: "R TV",
                          imagePath: AppImagesWebp.rTv,
                          themeColor: Colors.yellow),
                      CustomRotationAnimation(
                          title: "RESHERA BAZAR",
                          imagePath: AppImagesWebp.reshera,
                          themeColor: Colors.purple),
                      CustomRotationAnimation(
                          title: "SAMAAJ YOG",
                          imagePath: AppImagesWebp.samaaj,
                          themeColor: Color(0XFF03fcd3)),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesWebp.slide7,
                    AppImagesWebp.slide8,
                    AppImagesWebp.slide9,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: AppSize.height(0.02),
                    crossAxisSpacing: AppSize.width(0.02),
                    children: const [
                      CustomAnimatedDashboardCard(
                          title: "A ZAAP",
                          imagePath: AppImagesWebp.r,
                          themeColor: Colors.blueAccent),
                      CustomAnimatedDashboardCard(
                          title: "R RATH",
                          imagePath: AppImagesWebp.rRaath,
                          themeColor: Color(0XFFeb6250)),
                      CustomAnimatedDashboardCard(
                          title: "R DROP",
                          imagePath: AppImagesWebp.quick,
                          themeColor: Colors.orange),
                      CustomAnimatedDashboardCard(
                          title: "BIMA DUNIA",
                          imagePath: AppImagesWebp.bima,
                          themeColor: Color(0XFFeb6250)),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesWebp.slide10,
                    AppImagesWebp.slide11,
                    AppImagesWebp.slide12,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: const [
                      CustomFadeAnimatedDashboardCard(
                          title: "PATHSALA",
                          imagePath: AppImagesWebp.pathshala,
                          themeColor: Colors.orange),
                      CustomFadeAnimatedDashboardCard(
                          title: "RESHERA CLINIC",
                          imagePath: AppImagesWebp.clinic,
                          themeColor: Colors.blue),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: const [
                      CustomAnimatedDashboardCard(
                          title: "RESHERA ESTATE",
                          imagePath: AppImagesWebp.resheraE,
                          themeColor: Color(0XFFafaef5)),
                      CustomAnimatedDashboardCard(
                          title: "BUS 4U",
                          imagePath: AppImagesWebp.bus,
                          themeColor: Color(0XFFff47cb)),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesWebp.slide13,
                    AppImagesWebp.slide14,
                  ]),

                  SizedBox(height: AppSize.height(0.01)),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    mainAxisSpacing: AppSize.height(0.02),
                    crossAxisSpacing: AppSize.width(0.02),
                    children: const [
                      CustomRotationAnimation(
                          title: "JUST HIRE",
                          imagePath: AppImagesWebp.job,
                          themeColor: Colors.yellowAccent),
                      CustomRotationAnimation(
                          title: "AERO FLY",
                          imagePath: AppImagesWebp.aero,
                          themeColor: Colors.green),
                      CustomRotationAnimation(
                          title: "RESHERA ESTATE",
                          imagePath: AppImagesWebp.reshera,
                          themeColor: Color(0XFFafaef5)),
                      CustomRotationAnimation(
                          title: "BUS 4U",
                          imagePath: AppImagesWebp.samaaj,
                          themeColor: Color(0XFFff47cb)),
                    ],
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  const ReusableImageSlider(imagePaths: [
                    AppImagesWebp.banner1,
                    AppImagesWebp.banner2,
                  ]),

                  SizedBox(height: AppSize.height(0.12)), //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAnnouncementPopup(context);
    });
  }

  void showAnnouncementPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return AnnouncementPopupWidget(
          onClose: () => Navigator.pop(context), imagePath: 'assets/images/modal.webp',
        );
      },
    );
  }
}
