import 'package:flutter/material.dart';
import 'product_card_component.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, String>> products;
  final List<int> quantities;
  final Function(int) onAdd;
  final Function(int) onIncrease;
  final Function(int) onDecrease;

  const ProductGrid({
    super.key,
    required this.products,
    required this.quantities,
    required this.onAdd,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1, // 🔥 FIXED
      ),

      itemBuilder: (context, index) {
        final item = products[index];

        return ProductCard(
          image: item['image']!,
          title: item['title']!,
          subtitle: item['subtitle']!,
          price: item['price']!,
          quantity: quantities[index],
          onAdd: () => onAdd(index),
          onIncrease: () => onIncrease(index),
          onDecrease: () => onDecrease(index),
        );
      },
    );
  }
}