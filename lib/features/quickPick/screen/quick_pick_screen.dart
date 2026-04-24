import 'package:flutter/material.dart';
import 'package:resheragroup/core/constants/app_images_png.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_sizes.dart';
import 'package:resheragroup/features/dashboard/screen/dashboard_screen.dart';
import 'package:resheragroup/features/quickPick/model/category_model.dart';
import 'package:resheragroup/features/quickPick/screen/subCategory/sub_category_screeen.dart';
import 'package:resheragroup/features/quickPick/widgets/category_card_widget.dart';
import 'package:resheragroup/features/quickPick/widgets/custom_header_widget.dart';


import '../widgets/custom_quickpick_buttom_navigation.dart';

class QuickPickScreen extends StatefulWidget {
  const QuickPickScreen({super.key});

  @override
  State<QuickPickScreen> createState() => _QuickPickScreenState();
}

class _QuickPickScreenState extends State<QuickPickScreen> {
  late final List<CategoryModel> categories;
  int selectedIndex = 1; // Category selected by default

  @override
  void initState() {
    super.initState();

    categories = [
      CategoryModel(
        title: "Food & Beverages",
        image: AppImagesPng.grocery,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Food & Beverages"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Construction & Hardware",
        image: AppImagesPng.garments,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Construction & Hardware"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Home & Living",
        image: AppImagesPng.restuarant,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Home & Living"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Fashion & Lifestyle",
        image: AppImagesPng.electrical,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Fashion & Lifestyle"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Automobile",
        image: AppImagesPng.electrical,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Automobile"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Education & Stationery",
        image: AppImagesPng.pharmacy,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Education & Stationery"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Agriculture & Nature",
        image: AppImagesPng.furniture,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Agriculture & Nature"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Retail & General",
        image: AppImagesPng.toy,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Retail & General"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Health & Medical",
        image: AppImagesPng.book,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Health & Medical"),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Sports & Others",
        image: AppImagesPng.book,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubCategoryScreen(categoryTitle: "Sports & Others"),
            ),
          );
        },
      ),
    ];
  }

  void _onNavTap(int index) {
    if (index == 3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
            (route) => false,
      );
      return;
    }

    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        debugPrint("Navigate to Home Screen");
        break;
      case 1:
        debugPrint("Navigate to Category Screen");
        break;
      case 2:
        debugPrint("Navigate to Shopping Screen");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// 🔻 Bottom Navigation Bar
        bottomNavigationBar: CustomTopNavigationBar(
          selectedIndex: selectedIndex,
          onItemSelected: _onNavTap,
        ),

        /// 🔹 Main Content
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeaderWidget(
                userName: "Sk Mousin Ali",
                location: "Katju Nagar, Jadavpur",
                onNotificationTap: () {},
                onProfileTap: () {},
                onSearch: (value) {},
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(0.04),
                  vertical: AppSize.height(0.02),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.searchBycate,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: AppSize.width(0.045),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSize.height(0.015)),
                    GridView.count(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSize.width(0.02),
                      mainAxisSpacing: AppSize.height(0.015),
                      childAspectRatio: 1,
                      children: List.generate(
                        categories.length,
                            (index) {
                          final item = categories[index];
                          return CategoryCard(
                            title: item.title,
                            imagePath: item.image,
                            onTap: item.onTap,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}