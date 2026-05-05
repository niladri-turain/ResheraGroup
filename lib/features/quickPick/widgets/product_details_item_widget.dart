import 'package:flutter/material.dart';
import '../model/product_list_model.dart';
import '../../../../core/constants/app_sizes.dart';

class ProductDetailsItemWidget extends StatelessWidget {
  final ProductItem product;

  const ProductDetailsItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    // Static data as requested
    final List<String> staticSizes = ["S", "M", "L", "XL", "XXL"];
    final List<Color> staticColors = [
      const Color(0xFFE91E63), // Pink
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Amber/Yellow
      const Color(0xFF2196F3), // Blue
      const Color(0xFF000000), // Black
      const Color(0xFF9C27B0), // Purple
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Image.network(
            product.image ?? "https://bazaar.resheragroup.in/storage/business_sub_category/Restuarant.webp",
            width: double.infinity,
            height: AppSize.height(0.45),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: AppSize.height(0.45),
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 50),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            transform: Matrix4.translationValues(0, -24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Women Collection",
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Delivery on Tuesday, 15th Dec 2023",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Text(
                      "₹${product.finalPrice}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),

                      Text(
                        "₹${product.mrp}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${product.discount}% OFF",
                          style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],

                ),
                const SizedBox(height: 24),
                
                const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: staticSizes.length,
                    itemBuilder: (context, index) {
                      final size = staticSizes[index];
                      // Highlight XXL as in the design image
                      final isSelected = size == "XXL";
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF7B2CBF) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey[300]!),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                const Text("Available Colors", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: staticColors.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: staticColors[index],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                      );
                    },
                  ),
                ),
                
                const Divider(height: 48),

                const Text(
                  "Premium embroidered kurti set with soft fabric, elegant finish and festive-ready look. Perfect for casual outings, family functions and celebrations.",
                  style: TextStyle(color: Colors.black54, height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 100), // Spacing for bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
