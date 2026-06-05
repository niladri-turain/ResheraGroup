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

    // ডায়নামিক ভ্যালু ক্যালকুলেশন
    final double logoRadius = AppSize.width(0.09);
    final double logoOverlapOffset = -AppSize.width(0.13);
    final double leftPadding = AppSize.width(0.24);

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
                  borderRadius: BorderRadius.circular(AppSize.width(0.04)),
                  child: Image.network(
                    backgroundImage,
                    height: AppSize.height(0.20),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: AppSize.height(0.20),
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: logoOverlapOffset,
                  left: AppSize.width(0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: logoRadius,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: logoRadius - 3,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: NetworkImage(logo),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.height(0.002)),
            // Title and Info
            Padding(
              padding: EdgeInsets.only(left: leftPadding, right: AppSize.width(0.04)),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vendorId.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "($vendorId)",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: AppSize.width(0.030),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),

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
    );
  }
}