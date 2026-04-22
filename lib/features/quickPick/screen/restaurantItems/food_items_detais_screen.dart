import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/momo_distance_address_widget.dart';
import 'package:resheragroup/features/quickPick/screen/restaurantItems/restaurantItemWidgets/momo_list_item_widget.dart';

import '../groceryItems/groceryItemWidgets/custom_delivery_address_widget.dart';
import 'models/momo_item_model.dart';

class FoodItemsDetaisScreen extends StatefulWidget {
  const FoodItemsDetaisScreen({super.key});

  @override
  State<FoodItemsDetaisScreen> createState() => _FoodItemsDetaisScreenState();
}

class _FoodItemsDetaisScreenState extends State<FoodItemsDetaisScreen> {
  final List<MomoItemModel> items = [
    MomoItemModel(
      title: "Special Darjeeling Chicken Momos (6 pcs)",
      subtitle: "Enjoy our authentic Darjeeling style chicken momos...",
      price: "₹219",
      image: "assets/images/momo1.png",
    ),
    MomoItemModel(
      title: "Special Darjeeling Veg Momos (6 pcs)",
      subtitle: "Enjoy our authentic Darjeeling style veg momos...",
      price: "₹179",
      image: "assets/images/momo2.png",
    ),
    MomoItemModel(
      title: "Special Darjeeling Veg Momos (6 pcs)",
      subtitle: "Enjoy our authentic Darjeeling style veg momos...",
      price: "₹179",
      image: "assets/images/momo1.png",
    ),
    MomoItemModel(
      title: "Special Darjeeling Veg Momos (6 pcs)",
      subtitle: "Enjoy our authentic Darjeeling style veg momos...",
      price: "₹179",
      image: "assets/images/momo1.png",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /// TOP IMAGE

            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: DeliverAddressWidget(
                    address: "Katju Nagar,kolkata -7...",
                  ),
                ),

                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/wow.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),

            /// LIST CONTENT
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("WOW! Momo",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.w800),),
                      const LocationInfoRow(
                        distance: "1 km",
                        area: "Jodhpur Park",
                        time: "20–25 mins",
                      ),
                      const Divider(thickness: 0.75,),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = items[index];
                  
                          return MomoListItem(
                            title: item.title,
                            subtitle: item.subtitle,
                            price: item.price,
                            image: item.image,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
