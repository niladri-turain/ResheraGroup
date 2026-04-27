import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class VendorCard extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final String address;
  final String vendorId;
  final VoidCallback onTap;

  const VendorCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.address,
    required this.vendorId,
    required this.onTap,
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
            // Background Image
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
            const SizedBox(height: 10),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(

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
                    Column(
                      children: [
                        SizedBox(height: 3,),
                        Text(
                          " ($vendorId)",
                          style: TextStyle(

                            color: Colors.grey[500],
                            fontSize: AppSize.width(0.030),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                address.isNotEmpty ? address : "No address provided",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: AppSize.width(0.035),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
