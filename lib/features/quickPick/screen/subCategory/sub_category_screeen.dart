import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/core/service/location_service.dart';
import 'package:resheragroup/features/quickPick/screen/vendorList/vendor_list_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resheragroup/features/quickPick/provider/view_cart_list_provider.dart';
import 'package:resheragroup/features/quickPick/widgets/cart_widgets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/sub_category_provider.dart';
import '../../widgets/category_card_widget.dart';
import '../checkout/check_out_screen.dart';
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
  String? cachedAddress;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubCategoryProvider>().fetchSubCategories(widget.categoryId);
    });
  }

  Future<void> _loadAddress() async {
    final address = await LocationService.getCachedAddress();
    if (mounted) {
      setState(() {
        cachedAddress = address;
      });
    }
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (cachedAddress != null)
              Text(
                cachedAddress!,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppSize.width(0.032),
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          // Padding(
          //   padding:  EdgeInsets.only(right:AppSize.width(0.04)),
          //   child: Container(
          //     height: AppSize.width(0.10),
          //     width: AppSize.width(0.10),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       shape: BoxShape.circle,
          //     ),
          //
          //     child: IconButton(
          //       icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const CheckOutScreen()),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: AppSize.width(0.04),right:AppSize.width(0.04),bottom: AppSize.width(0.02) ),
                color: const Color(0xFF7B2CBF),
                child: CustomSearchWidget(
                  onSearch: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  hintText: 'Search in ${widget.categoryTitle}',
                ),
              ),
    
              Expanded(
                child: Consumer<SubCategoryProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.width(0.04),
                            vertical: AppSize.height(0.02)),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 8,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppSize.width(0.03),
                            mainAxisSpacing: AppSize.height(0.015),
                            childAspectRatio: 1.25,
                          ),
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppSize.width(0.04)),
                                ),
                              ),
                            );
                          },
                        ),
                      );
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
    
                    final filteredList = provider.subCategories.where((sub) {
                      return sub.name.toLowerCase().contains(_searchQuery);
                    }).toList();
    
                    if (provider.subCategories.isEmpty) {
                      return const Center(child: Text("No Sub-categories found"));
                    }
    
                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Text(
                          "no search item found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
    
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(0.04),
                        vertical: AppSize.height(0.02),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSize.width(0.02),
                          mainAxisSpacing: AppSize.height(0.015),
                          childAspectRatio: 1.25,
                        ),
                        itemBuilder: (context, index) {
                          final subCategory = filteredList[index];
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
                                  builder: (context) =>  VendorListScreen(
                                    categoryId: widget.categoryId,
                                    subCategoryId: subCategory.id,
                                    categoryName: widget.categoryTitle,
                                  ),
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
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Consumer<ViewCartListProvider>(
                builder: (context, cartProvider, child) {
                  return FloatingCartBar(
                    itemCount: cartProvider.totalItems,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
