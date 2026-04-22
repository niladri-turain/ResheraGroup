import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/food_items_detais_screen.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/custom_reusable_restaurant_card_widget.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/list_component_widget.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/restaurant_vender_model.dart';

import '../groceryItems/groceryItemWidgets/custom_delivery_address_widget.dart';

class RestaurantItemsScreen extends StatefulWidget {
  const RestaurantItemsScreen({super.key});

  @override
  State<RestaurantItemsScreen> createState() => _RestaurantItemsScreenState();
}

class _RestaurantItemsScreenState extends State<RestaurantItemsScreen> {
  List<RestaurantModel> venderList = [
    RestaurantModel(name: "WOW! Momo", image: "assets/images/wow.jpg"),
    RestaurantModel(name: "KFC", image: "assets/images/kfc.jpg"),
    RestaurantModel(name: "Pizza Hut", image: "assets/images/pizza.jpg"),
    RestaurantModel(name: "Domino's", image: "assets/images/dominos.jpg"),
    RestaurantModel(name: "Biryani House", image: "assets/images/biriyani.png"),


  ];
  List<Map<String, String>> restaurantList = [
    {
      "name": "WOW! Chicken by WOW! Momo",
      "image": "assets/images/wow.jpg",
      "items": "24 Items",
      "time": "20-30 mins",
      "price": "₹200 for two",
    },
    {
      "name": "The 99 Thali House",
      "image": "assets/images/thai.jpg",
      "items": "24 Items",
      "time": "20-30 mins",
      "price": "₹200 for two",
    },
    {
      "name": "Grill Master Shop",
      "image": "assets/images/checkin.jpg",
      "items": "24 Items",
      "time": "20-30 mins",
      "price": "₹200 for two",
    },
    {
      "name": "Grill Master Shop",
      "image": "assets/images/chow.jpg",
      "items": "24 Items",
      "time": "20-30 mins",
      "price": "₹200 for two",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: DeliverAddressWidget(address: "Katju Nagar,kolkata -7...",),
                ),
                Container(color: Color(0XFFf1f5f9),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Restaurants For You",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                        ),
                        const SizedBox(height: 10,),
                        RestaurantHorizontalList(items: venderList),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurantList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = restaurantList[index];

                    return RestaurantCard(
                      name: item["name"]!,
                      image: item["image"]!,
                      items: item["items"]!,
                      time: item["time"]!,
                      price: item["price"]!,
                      onTap: (){
                        if(item["name"]=="WOW! Chicken by WOW! Momo")
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const FoodItemsDetaisScreen()),
                            );
                          }
                      },
                    );
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
