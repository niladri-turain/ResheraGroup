import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String image;
  final String items;
  final String time;
  final String price;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.image,
    required this.items,
    required this.time,
    required this.price,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            // Meta Info
            Row(
              children: [
                Text(items, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 6),
                const Text("•", style: TextStyle(color:Color(0xffceaef3),fontSize: 22)),
                const SizedBox(width: 6),
                Text(time, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 6),
                const Text("•", style: TextStyle(color:Color(0xffceaef3),fontSize: 22)),
                const SizedBox(width: 6),
                Text(price, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}