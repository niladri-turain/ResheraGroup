import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/restaurant_vender_model.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/reusable_vender_card_component.dart';

class RestaurantHorizontalList extends StatelessWidget {
  final List<RestaurantModel> items;

  const RestaurantHorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return RestaurantCard(
            name: item.name,
            image: item.image,
          );
        },
      ),
    );
  }
}