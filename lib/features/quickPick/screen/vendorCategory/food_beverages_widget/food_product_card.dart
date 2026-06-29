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
        padding: const EdgeInsets.symmetric(vertical: 16),
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
                      size: 8,
                      color: isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppSize.width(0.04),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (product.description != null && product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: AppSize.width(0.032),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Text(
                    "₹${product.finalPrice}",
                    style: TextStyle(
                      fontSize: AppSize.width(0.04),
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
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      width: 110,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: -15,
                //   child: quantity == 0
                //       ? Container(
                //           decoration: BoxDecoration(
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.black.withValues(alpha: 0.1),
                //                 blurRadius: 4,
                //                 offset: const Offset(0, 2),
                //               ),
                //             ],
                //           ),
                //           child: ElevatedButton(
                //             onPressed: onAdd,
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.white,
                //               foregroundColor: const Color(0xFF7B2CBF),
                //               elevation: 0,
                //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(8),
                //                 side: BorderSide(color: Colors.grey.shade300),
                //               ),
                //             ),
                //             child: const Text("ADD", style: TextStyle(fontWeight: FontWeight.bold)),
                //           ),
                //         )
                //       : Container(
                //           height: 36,
                //           width: 90,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(8),
                //             border: Border.all(color: Colors.grey.shade300),
                //             boxShadow: const [
                //               BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                //             ],
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               IconButton(
                //                 icon: const Icon(Icons.remove, size: 16, color: Color(0xFF7B2CBF)),
                //                 onPressed: onRemove,
                //                 padding: EdgeInsets.zero,
                //                 constraints: const BoxConstraints(),
                //               ),
                //               Text(
                //                 quantity.toString(),
                //                 style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B2CBF)),
                //               ),
                //               IconButton(
                //                 icon: const Icon(Icons.add, size: 16, color: Color(0xFF7B2CBF)),
                //                 onPressed: onAdd,
                //                 padding: EdgeInsets.zero,
                //                 constraints: const BoxConstraints(),
                //               ),
                //             ],
                //           ),
                //         ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
