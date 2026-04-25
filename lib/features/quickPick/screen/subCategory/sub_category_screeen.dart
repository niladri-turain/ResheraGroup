import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/sub_category_provider.dart';
import '../../widgets/category_card_widget.dart';
import '../groceryItems/grocery_items_screens.dart';

import '../../../../widgets/custom_search_widget.dart';

class SubCategoryScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;

  const SubCategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
  });

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubCategoryProvider>().fetchSubCategories(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: AppSize.width(0.04),right:AppSize.width(0.04),bottom: AppSize.width(0.02) ),
            color: const Color(0xFF7B2CBF),
            child: CustomSearchWidget(
              onSearch: (value) {
                // Implement subcategory search logic here
              },
              hintText: 'Search in ${widget.categoryTitle}',
            ),
          ),

          Expanded(
            child: Consumer<SubCategoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => provider.fetchSubCategories(widget.categoryId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B2CBF),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.subCategories.isEmpty) {
                  return const Center(child: Text("No Sub-categories found"));
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(0.04),
                    vertical: AppSize.height(0.02),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.subCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSize.width(0.02),
                      mainAxisSpacing: AppSize.height(0.015),
                      childAspectRatio: 1.25,
                    ),
                    itemBuilder: (context, index) {
                      final subCategory = provider.subCategories[index];
                      return CategoryCard(
                        title: subCategory.name,
                        imagePath: subCategory.image,
                        isNetworkImage: true,
                        onTap: () {
                          debugPrint("Tapped on ${subCategory.name}");
                          // Navigate to Items screen if needed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GroceryItemsScreens(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
