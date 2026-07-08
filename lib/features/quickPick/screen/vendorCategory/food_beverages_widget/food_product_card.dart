import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../model/product_list_model.dart';
import '../../productDetails/product_details_screen.dart';

class FoodProductCard extends StatelessWidget {
  final ProductItem product;
  final String categoryId;
  final String businessCategoryId;
  final String businessSubCategoryId;
  final String businessId;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const FoodProductCard({
    super.key,
    required this.product,
    required this.categoryId,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.businessId,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;

    // Determine if it's Veg or Non-Veg based on description or name
    bool isVeg = true; // Default to Veg
    final desc = product.description?.toLowerCase() ?? "";
    final name = product.name.toLowerCase();

    if (desc.contains("chicken") || name.contains("chicken") ||
        desc.contains("meat") || name.contains("meat") ||
        desc.contains("egg") || name.contains("egg") ||
        desc.contains("non-veg") || name.contains("non-veg") ||
        desc.contains("mutton") || name.contains("mutton") ||
        desc.contains("fish") || name.contains("fish") ||
        desc.contains("prawn") || name.contains("prawn") ||
        desc.contains("pork") || name.contains("pork") ||
        desc.contains("beef") || name.contains("beef")) {
      isVeg = false;
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              businessCategoryId: businessCategoryId,
              businessSubCategoryId: businessSubCategoryId,
              categoryId: categoryId,
              productId: product.productId,
              businessId: businessId,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 24 : 16),
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
                  // Veg/Non-Veg icon
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: isVeg ? Colors.green : Colors.red, width: 1),
                    ),
                    child: Icon(
                      Icons.circle,
                      size: isTablet ? 12 : 8,
                      color: isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (product.description != null && product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isTablet ? 16 : 13,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Text(
                    "₹${product.finalPrice}",
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
                    height: isTablet ? 150 : 110,
                    width: isTablet ? 150 : 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: isTablet ? 150 : 110,
                      width: isTablet ? 150 : 110,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: isTablet ? 40 : 24, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
