import 'package:flutter/material.dart';

class VendorCard extends StatelessWidget {
  final String bgImage;
  final String logo;
  final String name;

  const VendorCard({
    super.key,
    required this.bgImage,
    required this.logo,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,

      margin: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          // 🔥 Black overlay
          Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3), // 👈 control darkness here
            ),
          ),

          // Content
          Positioned(
            bottom: 20,

            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(logo),
                  radius: 22,
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}