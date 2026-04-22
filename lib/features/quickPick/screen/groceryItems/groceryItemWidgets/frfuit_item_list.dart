import 'package:flutter/material.dart';

class FruitItem extends StatelessWidget {
  final String image;
  final String name;

  const FruitItem({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(height: 5),
          Text(name)
        ],
      ),
    );
  }
}