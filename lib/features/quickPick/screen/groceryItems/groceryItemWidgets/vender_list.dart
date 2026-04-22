import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/groceryItems/groceryItemWidgets/vender_card_component.dart';

class VendorList extends StatelessWidget {
  final List<Map<String, String>> vendors;

  const VendorList({super.key, required this.vendors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final item = vendors[index];
          return VendorCard(
            bgImage: item['bg']!,
            logo: item['logo']!,
            name: item['name']!,
          );
        },
      ),
    );
  }
}