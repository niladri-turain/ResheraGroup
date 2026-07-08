import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class CheckoutItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CheckoutItemWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 12, horizontal: isTablet ? 16 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image.startsWith('http')
                ? Image.network(
                    image,
                    width: isTablet ? 100 : 80,
                    height: isTablet ? 100 : 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: isTablet ? 100 : 80,
                      height: isTablet ? 100 : 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Image.asset(
                    image,
                    width: isTablet ? 100 : 80,
                    height: isTablet ? 100 : 80,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: isTablet ? 20 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 24 : 16,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: isTablet ? 20 : 14,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: isTablet ? 45 : 35,
                decoration: BoxDecoration(
                  color: const Color(0XFF9333ea),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove,
                          color: Colors.white, size: isTablet ? 24 : 18),
                      onPressed: onDecrease,
                      constraints: BoxConstraints(
                        minWidth: isTablet ? 45 : 35,
                        minHeight: isTablet ? 45 : 35,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 18 : 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.add,
                          color: Colors.white, size: isTablet ? 24 : 18),
                      onPressed: onIncrease,
                      constraints: BoxConstraints(
                        minWidth: isTablet ? 45 : 35,
                        minHeight: isTablet ? 45 : 35,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Price : ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    TextSpan(
                      text: '₹$price',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 18 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Final Price : ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 18 : 14,
                      ),
                    ),
                    TextSpan(
                      text:
                          '₹${((double.tryParse(price) ?? 0) * quantity).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
