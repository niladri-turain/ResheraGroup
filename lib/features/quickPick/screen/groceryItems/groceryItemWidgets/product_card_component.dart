import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            image,
            height: 90, // 🔥 reduce height (important)
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 6),

        /// TITLE
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        /// SUBTITLE
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),

        const SizedBox(height: 6),

        /// PRICE + BUTTON
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// 🔥 ADD / COUNTER
            quantity == 0
                ? GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color:  const Color(0XFF9333ea),),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "ADD",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            )
                : Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0XFF9333ea),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onDecrease,
                    child: const Icon(Icons.remove,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onIncrease,
                    child: const Icon(Icons.add,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}