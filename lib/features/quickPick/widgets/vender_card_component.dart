import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class VendorCard extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final String address;
  final String vendorId;
  final VoidCallback onTap;
  final String logo;

  const VendorCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.address,
    required this.vendorId,
    required this.onTap,
    required this.logo
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.height(0.02)),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image and Logo Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    backgroundImage,
                    height: AppSize.height(0.22),
                    width: double.infinity,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: AppSize.height(0.22),
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -25,
                  left: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(logo),

                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Title and Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(width: 85), // Offset for logo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: AppSize.width(0.045),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (vendorId.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  " ($vendorId)",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: AppSize.width(0.030),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Address
                        Text(
                          address.isNotEmpty ? address : "No address provided",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: AppSize.width(0.035),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
