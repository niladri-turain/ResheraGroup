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
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.height(0.015)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image.startsWith('http')
                ? Image.network(
                    image,
                    width: AppSize.width(0.15),
                    height: AppSize.width(0.15),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: AppSize.width(0.15),
                      height: AppSize.width(0.15),
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Image.asset(
                    image,
                    width: AppSize.width(0.15),
                    height: AppSize.width(0.15),
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: AppSize.width(0.03)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.width(0.04),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: AppSize.width(0.03),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: AppSize.height(0.038),

                decoration: BoxDecoration(
                  color: const Color(0XFF9333ea),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.white, size: AppSize.width(0.04)),
                      onPressed: onDecrease,
                      constraints: BoxConstraints(
                        minWidth: AppSize.width(0.08),
                        minHeight: AppSize.height(0.04),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),

                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: AppSize.width(0.04)),
                      onPressed: onIncrease,
                      constraints: BoxConstraints(
                        minWidth: AppSize.width(0.08),
                        minHeight: AppSize.height(0.04),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.height(0.005)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Price :',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: AppSize.width(0.04),
                      ),
                    ),
                    TextSpan(
                      text: '₹$price',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: AppSize.width(0.04),
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
                        fontSize: AppSize.width(0.04),
                      ),
                    ),
                    TextSpan(
                      text: '₹${((double.tryParse(price) ?? 0) * quantity).toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '')}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: AppSize.width(0.04),
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
