import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../screen/productDetails/product_details_screen.dart';

class StandardProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final String categoryId;
  final String businessCategoryId;
  final String businessSubCategoryId;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const StandardProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
                      businessCategoryId: businessCategoryId,
                      businessSubCategoryId: businessSubCategoryId,
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
                                businessCategoryId: businessCategoryId,
                                businessSubCategoryId: businessSubCategoryId,
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
                              onPressed: onAdd,
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
                                  onTap: onRemove,
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
                                  onTap: onAdd,
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
