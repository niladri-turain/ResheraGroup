import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class VendorCard extends StatelessWidget {
  final String title;
  final String backgroundImage;
  final String logoImage;
  final VoidCallback onTap;

  const VendorCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.logoImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  logoImage,
                  width: AppSize.width(0.12),
                  height: AppSize.width(0.12),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.store,
                    size: AppSize.width(0.12),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.height(0.01)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.width(0.045),
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
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
