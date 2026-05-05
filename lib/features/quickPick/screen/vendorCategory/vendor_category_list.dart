import 'package:resheragroup/core/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../productDetails/product_details_screen.dart';
import '../../provider/vendor_category_provider.dart';
import '../../provider/product_provider.dart';
import '../checkout/check_out_screen.dart';

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
                              if (products.isEmpty && !productProvider.isLoading)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: AppSize.height(0.02)),
                                  child: const Text("No products found in this category"),
                                )
                              else
                                for (var product in products)
                                  _buildProductItem(
                                    product.productId,
                                    product.name,
                                    product.description ?? "No description available",
                                    "₹${product.finalPrice}",
                                    product.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                                    category.id,
                                  ),
                            ],
                          );
                        },
                      ),
                      Container(
                        height: 8,
                        width: double.infinity,
                        color: Colors.grey.shade100, // Section Separator / Shadow look
                      ),
                    ],
                  );
                },
              );
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
                  return _buildFashionProductCard(
                    product.productId,
                    product.name,
                    "₹${product.finalPrice}",
                    product.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                    product.description ?? "",
                    _selectedCategoryId!,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFashionProductCard(String id, String title, String price, String imageUrl, String description, String categoryId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              businessCategoryId: widget.categoryId,
              businessSubCategoryId: widget.subCategoryId,
              categoryId: categoryId,
              productId: id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl,
                    height: AppSize.height(0.18),
                    width: double.infinity,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: AppSize.height(0.18),
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  description.trim().isNotEmpty
                      ? Text(
                          description,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(height: AppSize.height(0.02)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFF7B2CBF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                businessCategoryId: widget.categoryId,
                                businessSubCategoryId: widget.subCategoryId,
                                categoryId: categoryId,
                                productId: id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B2CBF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "View details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildProductItem(String id, String title, String subtitle, String price, String imageUrl, String categoryId) {
    final int quantity = _itemQuantities[id] ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.height(0.010)),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      businessCategoryId: widget.categoryId,
                      businessSubCategoryId: widget.subCategoryId,
                      categoryId: categoryId,
                      productId: id,
                    ),
                  ),
                );
              },
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
                  subtitle.trim().isNotEmpty && subtitle != "No description available"
                      ? Text(
                          subtitle, 
                          style: TextStyle(
                            color: Colors.grey.shade600, 
                            fontSize: AppSize.width(0.032),
                          ), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(height: AppSize.height(0.04)),
                  SizedBox(height: AppSize.height(0.012)),
                  Row(
                    children: [
                      Text(
                        price, 
                        style: TextStyle(
                          fontSize: AppSize.width(0.04), 
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7B2CBF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                businessCategoryId: widget.categoryId,
                                businessSubCategoryId: widget.subCategoryId,
                                categoryId: categoryId,
                                productId: id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B2CBF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "View details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                    child: quantity == 0 
                      ? SizedBox(
                          height: AppSize.height(0.04),
                          width: AppSize.width(0.2),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF7B2CBF)),
                              padding: EdgeInsets.zero,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _updateQuantity(id, 1),
                            child: Text(
                              "ADD", 
                              style: TextStyle(
                                color: const Color(0xFF7B2CBF), 
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.width(0.032),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: AppSize.height(0.04),
                          width: AppSize.width(0.22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF7B2CBF)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _updateQuantity(id, -1),
                                child: Container(
                                  width: AppSize.width(0.07),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.remove, size: 16, color: Color(0xFF7B2CBF)),
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  color: const Color(0xFF7B2CBF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSize.width(0.035),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _updateQuantity(id, 1),
                                child: Container(
                                  width: AppSize.width(0.07),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.add, size: 16, color: Color(0xFF7B2CBF)),
                                ),
                              ),
                            ],
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
