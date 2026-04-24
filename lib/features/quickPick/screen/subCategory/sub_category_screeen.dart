import 'package:flutter/material.dart';
import '../../../../core/constants/app_images_png.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../widgets/category_card_widget.dart';

class SubCategoryScreen extends StatelessWidget {
  final String categoryTitle;

  SubCategoryScreen({super.key, required this.categoryTitle});

  final Map<String, List<String>> subCategories = {
    "Food & Beverages": [
      "Restaurant",
      "Fast Food",
      "Cafe",
      "Tea House",
      "Sweet Shop",
      "Cake Shop & Bakery",
      "Ice Cream Parlour",
      "Egg Shop",
      "Raw Meat (Chicken / Fish / Mutton)",
      "Fruits",
      "Fresh Vegetables",
      "Groceries",
      "Departmental Store",
      "Dry Fruits",
      "Home Made Food Products",
      "Factory Made Food Products"
    ],
    "Construction & Hardware": [
      "Hardware Shop",
      "Builders",
      "Marble & Tiles",
      "Electric Materials",
      "Ply Shop",
      "Home Paint"
    ],
    "Home & Living": ["Furniture", "Home Decoration", "Home Interior"],
    "Fashion & Lifestyle": [
      "Fashion (Male / Female)",
      "Winter Wear",
      "Shoes",
      "Watches",
      "Bags & Luggage",
      "Boutiques",
      "Cosmetics & Imitation Jewellery",
      "Jewellery Shop"
    ],
    "Automobile": [
      "Pre-Owned Cars & Bikes",
      "Battery",
      "Tyres",
      "Car Decor Items"
    ],
    "Education & Stationery": ["Book / Pen / Pencil", "Stationery Goods"],
    "Agriculture & Nature": [
      "Agriculture",
      "Nursery (Plants / Flowers)",
      "Nursery (Fish)",
      "Flower Shop"
    ],
    "Retail & General": [
      "Gift Shop",
      "Printing Press",
      "Sculptor Making",
      "Agarbatti Sticks",
      "Dashakarma (Puja Items)"
    ],
    "Health & Medical": ["Medicine"],
    "Sports & Others": ["Sports"],
  };

  @override
  Widget build(BuildContext context) {
    final list = subCategories[categoryTitle.trim()] ?? [];
    AppSize.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: list.isEmpty
          ? const Center(child: Text("No Sub-categories found"))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(0.04),
                vertical: AppSize.height(0.02),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSize.width(0.02),
                  mainAxisSpacing: AppSize.height(0.015),
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    title: list[index],
                    // যেহেতু সাব-ক্যাটাগরির জন্য আলাদা ইমেজ নেই, তাই আমরা ক্যাটাগরির লজিক অনুযায়ী কোনো ডিফল্ট ইমেজ বা আইকন ব্যবহার করতে পারি।
                    imagePath: AppImagesPng.toy,
                    onTap: () {
                      debugPrint("Tapped on ${list[index]}");
                      // এখানে নির্দিষ্ট সাব-ক্যাটাগরির আইটেম পেজে যাওয়ার লজিক দিতে পারেন।
                    },
                  );
                },
              ),
            ),
    );
  }
}
