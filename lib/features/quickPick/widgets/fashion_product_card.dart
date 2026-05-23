import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../screen/productDetails/product_details_screen.dart';

class FashionProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String description;
  final String categoryId;
  final String businessCategoryId;
  final String businessSubCategoryId;
  final String businessId;
  final int initialCount;
  final Function(int) onCountChanged;

  const FashionProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.categoryId,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.businessId,
    this.initialCount = 0,
    required this.onCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              businessCategoryId: businessCategoryId,
              businessSubCategoryId: businessSubCategoryId,
              categoryId: categoryId,
              productId: id,
              businessId: businessId,
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
                      : SizedBox(height: AppSize.height(0.0)),
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

                    ],
                  ),
                  const SizedBox(height: 8),
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
                            businessId: businessId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF7B2CBF).withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "View details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF7B2CBF),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
