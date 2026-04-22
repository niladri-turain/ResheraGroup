import 'package:flutter/material.dart';
import 'package:resheragroup/core/constants/app_images_png.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_sizes.dart';
import 'package:resheragroup/features/dashboard/screen/dashboard_screen.dart';
import 'package:resheragroup/features/quickPick/model/category_model.dart';
import 'package:resheragroup/features/quickPick/screen/groceryItems/grocery_items_screens.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurant_items_screen.dart';
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
        title: "Grocery & Essentials",
        image: AppImagesPng.grocery,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const GroceryItemsScreens(),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Fashion & Apparel",
        image: AppImagesPng.garments,
        onTap: () => debugPrint("Fashion"),
      ),
      CategoryModel(
        title: "Restaurant",
        image: AppImagesPng.restuarant,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RestaurantItemsScreen(),
            ),
          );
        },
      ),
      CategoryModel(
        title: "Electronics & Gadgets",
        image: AppImagesPng.electrical,
        onTap: () => debugPrint("Electronics"),
      ),
      CategoryModel(
        title: "Health & Pharmacy",
        image: AppImagesPng.pharmacy,
        onTap: () => debugPrint("Health"),
      ),
      CategoryModel(
        title: "Home & Furniture",
        image: AppImagesPng.furniture,
        onTap: () => debugPrint("Home"),
      ),
      CategoryModel(
        title: "Toys,Baby & Kids",
        image: AppImagesPng.toy,
        onTap: () => debugPrint("Toys"),
      ),
      CategoryModel(
        title: "Books & Education",
        image: AppImagesPng.book,
        onTap: () => debugPrint("Books"),
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