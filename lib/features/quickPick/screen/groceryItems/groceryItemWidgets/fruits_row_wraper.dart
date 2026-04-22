import 'package:flutter/material.dart';

import 'frfuit_item_list.dart';

class FruitsList extends StatelessWidget {
  final List<Map<String, String>> fruits;

  const FruitsList({super.key, required this.fruits});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final item = fruits[index];
          return FruitItem(
            image: item['image']!,
            name: item['name']!,
          );
        },
      ),
    );
  }
}