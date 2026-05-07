import 'package:resheragroup/core/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../productDetails/product_details_screen.dart';
import '../../provider/vendor_category_provider.dart';
import '../../provider/product_provider.dart';
import '../checkout/check_out_screen.dart';
import '../../widgets/fashion_product_card.dart';
import '../../widgets/standard_product_card.dart';

class VendorCategoryList extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String vendorId;
  final String categoryName;

  const VendorCategoryList({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.vendorId,
    required this.categoryName,
  });

  @override
  State<VendorCategoryList> createState() => _VendorCategoryListState();
}

class _VendorCategoryListState extends State<VendorCategoryList> {
  String? cachedAddress;
  // To track quantities of items: {itemId: quantity}
  final Map<String, int> _itemQuantities = {};

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorCategoryProvider>().fetchVendorCategories(
        widget.categoryId,
        widget.subCategoryId,
        widget.vendorId,
      ).then((_) {
        final catProvider = context.read<VendorCategoryProvider>();
        if (catProvider.categories.isNotEmpty) {
          setState(() {
            _selectedCategoryId = catProvider.categories.first.id;
          });
        }
        
        final categories = catProvider.categories;
        for (var category in categories) {
          context.read<ProductProvider>().fetchProducts(
            businessCategoryId: widget.categoryId,
            businessSubCategoryId: widget.subCategoryId,
            categoryId: category.id,
          );
        }
      });
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

  void _updateQuantity(String itemId, int delta) {
    setState(() {
      final currentQty = _itemQuantities[itemId] ?? 0;
      final newQty = currentQty + delta;
      if (newQty <= 0) {
        _itemQuantities.remove(itemId);
      } else {
        _itemQuantities[itemId] = newQty;
      }
    });
  }

  int get totalItems => _itemQuantities.values.fold(0, (sum, item) => sum + item);

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
              "Vendor Categories",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.width(0.045),
              ),
            ),
            if (cachedAddress != null)
              Text(
                cachedAddress!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right:AppSize.width(0.04)),
            child: Container(
              height: AppSize.width(0.10),
              width: AppSize.width(0.10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),

              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<VendorCategoryProvider>(
            builder: (context, catProvider, child) {
              if (catProvider.isLoading) {
                return _buildSkeletonLoader();
              }
              if (catProvider.categories.isEmpty) {
                return const Center(child: Text("No categories found"));
              }

              if (widget.categoryName == "Fashion & Lifestyle") {
                return _buildFashionLayout(catProvider);
              }
              return _buildStandardLayout(catProvider);
            },
          ),
          if (totalItems > 0)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.46, // 🔥 responsive width
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckOutScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0XFF9333ea),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View Cart ($totalItems items)",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
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

  Widget _buildStandardLayout(VendorCategoryProvider catProvider) {
    return ListView.builder(
      itemCount: catProvider.categories.length,
      itemBuilder: (context, index) {
        final category = catProvider.categories[index];
        return Column(
          children: [
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.getProductsByCategory(category.id);

                return ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: AppSize.width(0.045),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  shape: const Border(),
                  childrenPadding: EdgeInsets.symmetric(horizontal: AppSize.width(0.04)),
                  children: [
                    if (products.isEmpty && !productProvider.isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.height(0.02)),
                        child: const Text("No products found in this category"),
                      )
                    else
                      for (var product in products)
                        StandardProductCard(
                          id: product.productId,
                          title: product.name,
                          subtitle: product.description ?? "No description available",
                          price: "₹${product.finalPrice}",
                          imageUrl: product.image ??
                              "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                          categoryId: category.id,
                          businessCategoryId: widget.categoryId,
                          businessSubCategoryId: widget.subCategoryId,
                          businessId: product.business?.businessId ?? "",
                          quantity: _itemQuantities[product.productId] ?? 0,
                          onAdd: () => _updateQuantity(product.productId, 1),
                          onRemove: () => _updateQuantity(product.productId, -1),
                        ),
                  ],
                );
              },
            ),
            Container(
              height: 8,
              width: double.infinity,
              color: Colors.grey.shade100,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFashionLayout(VendorCategoryProvider catProvider) {
    return Column(
      children: [
        // Horizontal circular categories
        Container(
          height: AppSize.height(0.12),
          padding: EdgeInsets.symmetric(vertical: AppSize.height(0.01)),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catProvider.categories.length,
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.02)),
            itemBuilder: (context, index) {
              final category = catProvider.categories[index];
              final isSelected = _selectedCategoryId == category.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryId = category.id;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.02)),
                  child: Column(
                    children: [
                      Container(
                        width: AppSize.width(0.14),
                        height: AppSize.width(0.14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey.shade300,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(category.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.005)),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: AppSize.width(0.03),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF7B2CBF) : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Filter and Sort row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.04), vertical: AppSize.height(0.01)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Products",
                style: TextStyle(
                  fontSize: AppSize.width(0.045),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: Color(0xFF7B2CBF)),
                onPressed: () => _showFilterBottomSheet(),
              ),
            ],
          ),
        ),
        // Grid of products
        Expanded(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final products = _selectedCategoryId == null 
                  ? [] 
                  : productProvider.getProductsByCategory(_selectedCategoryId!);

              if (productProvider.isLoading && products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (products.isEmpty) {
                return const Center(child: Text("No products found in this category"));
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.04)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: AppSize.width(0.04),
                  mainAxisSpacing: AppSize.width(0.04),
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return FashionProductCard(
                    businessId: product.business?.businessId ?? "",
                    id: product.productId,
                    title: product.name,
                    price: "₹${product.finalPrice}",
                    imageUrl: product.image ??
                        "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                    description: product.description ?? "",
                    categoryId: _selectedCategoryId!,
                    businessCategoryId: widget.categoryId,
                    businessSubCategoryId: widget.subCategoryId,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sort By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text("Price: Low to High"),
                leading: const Icon(Icons.trending_up),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text("Price: High to Low"),
                leading: const Icon(Icons.trending_down),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              const Text("Filter By Brand", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Add brand filters here
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Apply Filters", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
