import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/vendor_category_provider.dart';

class VendorCategoryList extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String vendorId;

  const VendorCategoryList({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.vendorId,
  });

  @override
  State<VendorCategoryList> createState() => _VendorCategoryListState();
}

class _VendorCategoryListState extends State<VendorCategoryList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorCategoryProvider>().fetchVendorCategories(
        widget.categoryId,
        widget.subCategoryId,
        widget.vendorId,
      );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Vendor Categories",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: AppSize.width(0.045),
          ),
        ),
      ),
      body: Consumer<VendorCategoryProvider>(
        builder: (context, catProvider, child) {
          if (catProvider.isLoading) {
            return _buildSkeletonLoader();
          }
          if (catProvider.categories.isEmpty) {
            return const Center(child: Text("No categories found"));
          }
          return ListView.builder(
            itemCount: catProvider.categories.length,
            itemBuilder: (context, index) {
              final category = catProvider.categories[index];
              return ExpansionTile(
                initiallyExpanded: true, // ওপেন হয়ে থাকবে
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: AppSize.width(0.045), 
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87,
                  ),
                ),
                shape: const Border(), // Removes the default borders
                childrenPadding: EdgeInsets.symmetric(horizontal: AppSize.width(0.04)),
                children: [
                  // Dummy Items for now to show the design
                  for (int i = 0; i < 3; i++)
                    _buildProductItem(
                      "Special Item ${i + 1}",
                      "Description for special item ${i + 1} will go here. It is tasty and fresh.",
                      "₹219",
                      category.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              ListTile(
                title: Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 15, width: 150, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(height: 12, width: double.infinity, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(height: 15, width: 60, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(height: 80, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductItem(String title, String subtitle, String price, String imageUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.height(0.010)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    fontSize: AppSize.width(0.04), 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSize.height(0.004)),
                Text(
                  subtitle, 
                  style: TextStyle(
                    color: Colors.grey.shade600, 
                    fontSize: AppSize.width(0.032),
                  ), 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSize.height(0.012)),
                Text(
                  price, 
                  style: TextStyle(
                    fontSize: AppSize.width(0.04), 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSize.width(0.03)),
          SizedBox(
            height: AppSize.height(0.14),
            width: AppSize.width(0.28),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: AppSize.height(0.11),
                    width: AppSize.width(0.28),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300], 
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppSize.height(0.008),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      height: AppSize.height(0.04),
                      width: AppSize.width(0.2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF7B2CBF)),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "ADD", 
                          style: TextStyle(
                            color: const Color(0xFF7B2CBF), 
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.width(0.032),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
