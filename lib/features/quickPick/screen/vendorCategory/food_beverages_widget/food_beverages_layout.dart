import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/promotional_vendor_banner_provider.dart';
import '../../../provider/vendor_category_provider.dart';
import '../../../widgets/main_vendor_slider_widget.dart';
import 'food_product_card.dart';

class FoodBeveragesLayout extends StatefulWidget {
  final VendorCategoryProvider catProvider;
  final String businessCategoryId;
  final String businessSubCategoryId;
  final String vendorId;
  final Map<String, int> itemQuantities;
  final Function(String, int) onUpdateQuantity;

  const FoodBeveragesLayout({
    super.key,
    required this.catProvider,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.vendorId,
    required this.itemQuantities,
    required this.onUpdateQuantity,
  });

  @override
  State<FoodBeveragesLayout> createState() => _FoodBeveragesLayoutState();
}

class _FoodBeveragesLayoutState extends State<FoodBeveragesLayout> {
  // Track which categories are expanded. Initially all are expanded.
  final Map<String, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    for (var category in widget.catProvider.categories) {
      _expandedState[category.id] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Consumer2<ProductProvider, PromotionalVendorBannerProvider>(
      builder: (context, productProvider, promoProvider, child) {
        final promoBanners = promoProvider.bannerModel?.data ?? [];

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            // Top Slider/Banner
            MainVendorSliderWidget(businessId: widget.vendorId),
            const SizedBox(height: 5),
            // Categories as Expandable Banners
            ...List.generate(widget.catProvider.categories.length, (catIndex) {
              final category = widget.catProvider.categories[catIndex];
              final isExpanded = _expandedState[category.id] ?? true;
              final products = productProvider.getProductsByCategory(category.id);

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandedState[category.id] = !isExpanded;
                      });
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                          ),
                          child: Image.network(
                            category.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                            height: isTablet ? 300 : MediaQuery.of(context).size.height * 0.25,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: isTablet ? 300 : MediaQuery.of(context).size.height * 0.25,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: isTablet ? 60 : 40, color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          height: isTablet ? 300 : MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, isTablet ? -45 : -35),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                        vertical: isTablet ? 28 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isTablet ? 40 : 30),
                          topRight: Radius.circular(isTablet ? 40 : 30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: isTablet ? 30 : 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          size: isTablet ? 20 : 14,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "25-30 mins • 1.2 km • Best Sellers",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: isTablet ? 16 : 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: isTablet ? 40 : 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _expandedState[category.id] = !isExpanded;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Enjoy a wide range of delicious food & beverages specially curated for you. Authentic taste and fresh ingredients guaranteed.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: isTablet ? 18 : 13,
                              height: 1.4,
                            ),
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            products.isEmpty && !productProvider.isLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(child: Text("No products available")),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final p = products[index];
                                      return FoodProductCard(
                                        product: p,
                                        categoryId: category.id,
                                        businessCategoryId: widget.businessCategoryId,
                                        businessSubCategoryId: widget.businessSubCategoryId,
                                        businessId: widget.vendorId,
                                        quantity: widget.itemQuantities[p.productId] ?? 0,
                                        onAdd: () => widget.onUpdateQuantity(p.productId, 1),
                                        onRemove: () => widget.onUpdateQuantity(p.productId, -1),
                                      );
                                    },
                                  ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  // Show promotional banner after each category (if available)
                  if (promoBanners.isNotEmpty) 
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isTablet ? 24 : 14,
                        0,
                        isTablet ? 24 : 14,
                        isTablet ? 24 : 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          promoBanners[catIndex % promoBanners.length].image ?? "",
                          width: double.infinity,
                          height: isTablet ? 250 : 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 100), // Space for floating cart
          ],
        );
      },
    );
  }
}
