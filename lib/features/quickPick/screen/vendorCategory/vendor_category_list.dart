import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/model/user_address_model.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import 'package:resheragroup/core/service/location_service.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_images_png.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../dashboard/widgets/reusable_slider.dart';
import '../../model/promotional_vendor_banner_model.dart';
import '../../model/vendor_list_model.dart';
import '../../provider/main_vendor_banner_provider.dart';
import '../../provider/vendor_provider.dart';
import '../productDetails/product_details_screen.dart';
import '../../provider/vendor_category_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/view_cart_list_provider.dart';
import '../checkout/check_out_screen.dart';
import '../../widgets/fashion_product_card.dart';
import '../../widgets/standard_product_card.dart';
import '../../widgets/cart_widgets.dart';
import '../../widgets/main_vendor_slider_widget.dart';
import '../../provider/promotional_vendor_banner_provider.dart';
import 'food_beverages_widget/food_beverages_layout.dart';

class VendorCategoryList extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String vendorId;
  final String categoryName;
  final String bannerLogo;
  final String vendorName;

  const VendorCategoryList({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.vendorId,
    required this.categoryName,
    this.bannerLogo = "",
    this.vendorName = "",
  });

  @override
  State<VendorCategoryList> createState() => _VendorCategoryListState();
}

class _VendorCategoryListState extends State<VendorCategoryList> {
  String currentLocation = "Fetching location...";
  // To track quantities of items: {itemId: quantity}
  final Map<String, int> _itemQuantities = {};

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainVendorBannerProvider>().fetchMainVendorBanners(businessId: widget.vendorId);
      context.read<PromotionalVendorBannerProvider>().fetchPromotionalBanners(businessId: widget.vendorId);
      // Sync initial cart quantities
      final cartProvider = context.read<ViewCartListProvider>();
      if (cartProvider.cartData?.data != null) {
        for (var item in cartProvider.cartData!.data!) {
          if (item.productId != null && item.quantity != null) {
            _itemQuantities[item.productId!] = item.quantity!;
          }
        }
      }

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
            vendorId: widget.vendorId
          );
        }
      });
    });
  }

  Future<void> _loadInitialData() async {
    final prefService = sl<SharedPrefService>();
    final token = await prefService.getToken();

    if (token != null && token.isNotEmpty) {
      final addressProvider = context.read<UserAddressProvider>();
      if (addressProvider.addressModel == null) {
        await addressProvider.fetchUserAddresses(token);
      }
      
      final addresses = addressProvider.addressModel?.data?.shipping;
      if (addresses != null && addresses.isNotEmpty && addressProvider.selectedAddress == null) {
        addressProvider.setSelectedAddress(addresses.first);
      }
    }
    
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    String address = await LocationService.getCurrentAddress();
    if (mounted) {
      setState(() {
        currentLocation = address;
      });
    }
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressSelectionSheet(
          selectedAddress: context.read<UserAddressProvider>().selectedAddress,
          onAddressSelected: (addr) {
            context.read<UserAddressProvider>().setSelectedAddress(addr);
          },
        );
      },
    );
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

    // Sync with global cart provider
    final qty = _itemQuantities[itemId] ?? 0;
    context.read<ViewCartListProvider>().fetchCart(
      productId: itemId,
      businessCategoryId: widget.categoryId,
      quantity: qty,
    );
  }

  int get totalItems => _itemQuantities.values.fold(0, (sum, item) => sum + item);

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: isTablet ? 90 : 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: isTablet ? 25 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: isTablet ? 28 : 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: isTablet ? 28 : 18,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: NetworkImage(widget.bannerLogo),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer2<LoginProvider, UserAddressProvider>(
                builder: (context, loginProvider, addressProvider, child) {
                  String displayLocation = currentLocation;
                  if (addressProvider.selectedAddress != null) {
                    displayLocation = addressProvider.selectedAddress!.address ?? "";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.vendorName ?? "Vendor Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 24 : 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: loginProvider.userName != null ? _showAddressBottomSheet : null,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            displayLocation,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 20 : 13,
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              final catProvider = context.read<VendorCategoryProvider>();
              await catProvider.fetchVendorCategories(
                widget.categoryId,
                widget.subCategoryId,
                widget.vendorId,
              );
              
              if (catProvider.categories.isNotEmpty) {
                if (_selectedCategoryId == null) {
                  setState(() {
                    _selectedCategoryId = catProvider.categories.first.id;
                  });
                }
                
                // Refresh products for all categories
                for (var category in catProvider.categories) {
                  await context.read<ProductProvider>().fetchProducts(
                    businessCategoryId: widget.categoryId,
                    businessSubCategoryId: widget.subCategoryId,
                    categoryId: category.id,
                    vendorId: widget.vendorId,
                  );
                }
              }
              
              // Refresh banners
              await context.read<MainVendorBannerProvider>().fetchMainVendorBanners(businessId: widget.vendorId);
              await context.read<PromotionalVendorBannerProvider>().fetchPromotionalBanners(businessId: widget.vendorId);
            },
            child: Consumer<VendorCategoryProvider>(
              builder: (context, catProvider, child) {
                if (catProvider.isLoading) {
                  return _buildSkeletonLoader();
                }
                if (catProvider.categories.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: AppSize.height(0.4)),
                      const Center(child: Text("No categories found")),
                    ],
                  );
                }

                return _buildMainLayout(catProvider);
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Consumer<ViewCartListProvider>(
              builder: (context, cartProvider, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingCartBar(
                    itemCount: cartProvider.totalItems,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutScreen(
                            vendorName: widget.vendorName,
                            vendorKycId: context.read<VendorProvider>().vendorCategory.firstWhere((v) => v.id == widget.vendorId, orElse: () => Vendor(id: '', businessName: '')).kycDetail?.id,
                          ),
                        ),
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

  Widget _buildMainLayout(VendorCategoryProvider catProvider) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    bool isFashion = widget.categoryName == "Fashion & Lifestyle" ||
        widget.categoryName.toLowerCase().contains("fashion");
    bool isFood = widget.categoryName == "Food & Beverages" ||
        widget.categoryName.toLowerCase().contains("food");

    if (isFood) {
      return FoodBeveragesLayout(
        catProvider: catProvider,
        businessCategoryId: widget.categoryId,
        businessSubCategoryId: widget.subCategoryId,
        vendorId: widget.vendorId,
        itemQuantities: _itemQuantities,
        onUpdateQuantity: _updateQuantity,
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        // show main banner slider
        const SizedBox(height: 10),
        MainVendorSliderWidget(businessId: widget.vendorId),

        // Horizontal circular categories
        Container(
          height: isTablet ? 150 : 100,
          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catProvider.categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        width: isTablet ? 80 : 56,
                        height: isTablet ? 80 : 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey.shade300,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(category.image ??
                                "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 12,
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
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24 : 16,
            vertical: isTablet ? 16 : 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Products",
                style: TextStyle(
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Grid or List of products
        Consumer2<ProductProvider, PromotionalVendorBannerProvider>(
          builder: (context, productProvider, promoProvider, child) {
            final products = _selectedCategoryId == null
                ? []
                : productProvider.getProductsByCategory(_selectedCategoryId!);

            if (productProvider.isLoading && products.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (products.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text("No products found in this category")),
              );
            }

            final banners = promoProvider.bannerModel?.data ?? [];

            // logic to interleave products and banners
            List<dynamic> uiItems = [];
            int columnCount = isTablet ? 3 : 2;

            if (isFashion) {
              // Grid logic
              for (int i = 0; i < products.length; i += columnCount) {
                List<dynamic> row = [];
                for (int j = 0; j < columnCount; j++) {
                  if (i + j < products.length) {
                    row.add(products[i + j]);
                  }
                }
                uiItems.add(row);
                
                // Add banner after every 2 rows
                if ((i + columnCount) % (columnCount * 2) == 0 && banners.isNotEmpty) {
                  int bannerIndex = ((i + columnCount) ~/ (columnCount * 2) - 1) % banners.length;
                  uiItems.add(banners[bannerIndex]);
                }
              }
            } else {
              // List logic: every 2 products, 1 banner (full width)
              for (int i = 0; i < products.length; i++) {
                uiItems.add(products[i]);
                if ((i + 1) % 2 == 0 && banners.isNotEmpty) {
                  int bannerIndex = ((i + 1) ~/ 2 - 1) % banners.length;
                  uiItems.add(banners[bannerIndex]);
                }
              }
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              itemCount: uiItems.length,
              itemBuilder: (context, index) {
                final item = uiItems[index];

                if (item is PromotionalBannerData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        item.image ?? "",
                        width: double.infinity,
                        height: isTablet ? 250 : 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: isTablet ? 250 : 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                }

                if (isFashion && item is List<dynamic>) {
                  // It's a row of products for Fashion grid
                  final productRow = item;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(columnCount, (colIndex) {
                        if (colIndex < productRow.length) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: colIndex < columnCount - 1 ? (isTablet ? 16.0 : 8.0) : 0,
                              ),
                              child: FashionProductCard(
                                businessId: productRow[colIndex].business?.businessId ?? "",
                                id: productRow[colIndex].productId,
                                title: productRow[colIndex].name,
                                price: "₹${productRow[colIndex].finalPrice}",
                                imageUrl: productRow[colIndex].image ??
                                    "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                                description: productRow[colIndex].description ?? "",
                                categoryId: _selectedCategoryId!,
                                businessCategoryId: widget.categoryId,
                                businessSubCategoryId: widget.subCategoryId,
                                isFashion: isFashion,
                                onCountChanged: (count) {
                                  _updateQuantity(productRow[colIndex].productId,
                                      count - (_itemQuantities[productRow[colIndex].productId] ?? 0));
                                },
                                initialCount: _itemQuantities[productRow[colIndex].productId] ?? 0,
                              ),
                            ),
                          );
                        } else {
                          return const Expanded(child: SizedBox.shrink());
                        }
                      }),
                    ),
                  );
                } else if (!isFashion) {
                  // It's a single product for Standard list
                  final p = item;
                  return StandardProductCard(
                    id: p.productId,
                    title: p.name,
                    subtitle: p.description ?? "No description available",
                    price: "₹${p.finalPrice}",
                    imageUrl: p.image ??
                        "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                    categoryId: _selectedCategoryId!,
                    businessCategoryId: widget.categoryId,
                    businessSubCategoryId: widget.subCategoryId,
                    businessId: p.business?.businessId ?? "",
                    isFashion: isFashion,
                    quantity: _itemQuantities[p.productId] ?? 0,
                    onAdd: () => _updateQuantity(p.productId, 1),
                    onRemove: () => _updateQuantity(p.productId, -1),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
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
