import 'package:flutter/material.dart';

import 'groceryItemWidgets/custom_delivery_address_widget.dart';
import 'groceryItemWidgets/fruits_row_wraper.dart';
import 'groceryItemWidgets/product_grid_section.dart';
import 'groceryItemWidgets/vender_list.dart';

class GroceryItemsScreens extends StatefulWidget {
  const GroceryItemsScreens({super.key});

  @override
  State<GroceryItemsScreens> createState() => _GroceryItemsScreensState();
}

class _GroceryItemsScreensState extends State<GroceryItemsScreens> {
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    quantities = List.generate(products.length, (_) => 0);
  }
  int get totalItems =>
      quantities.fold(0, (sum, item) => sum + item);
  final vendors = [
    {
      "bg": "assets/images/Spence.jpg",
      "logo": "assets/images/spen.jpg",
      "name": "Spencer"
    },
    {
      "bg": "assets/images/BigBasket.jpg",
      "logo": "assets/images/images.png",
      "name": "BigBasket"
    },
    {
      "bg": "assets/images/jiomart-site.jpg",
      "logo": "assets/images/jiomart.jpg",
      "name": "Jio Mart"
    },
  ];
  final fruits = [
    {"image": "assets/images/apple.jpg", "name": "Apple"},
    {"image": "assets/images/2.jpg", "name": "Grapes"},
    {"image": "assets/images/bananna.jpg", "name": "Banana"},
    {"image": "assets/images/str.jpg", "name": "Strawberry"},
    {"image": "assets/images/mango.jpg", "name": "Mango"},
  ];
  final products = [
    {
      "image": "assets/images/01.jpg",
      "title": "Fresh Banana",
      "subtitle": "Premium Farm Fresh Banana",
      "price": "₹60"
    },
    {
      "image": "assets/images/2.jpg",
      "title": "Black Grapes",
      "subtitle": "Seedless grapes",
      "price": "₹103"
    },
    {
      "image": "assets/images/3.jpg",
      "title": "Orange",
      "subtitle": "Juicy oranges",
      "price": "₹89"
    },
    {
      "image": "assets/images/4.jpg",
      "title": "Red Apple",
      "subtitle": "Washington apple",
      "price": "₹120"
    },
    {
      "image": "assets/images/1.jpg",
      "title": "Banana",
      "subtitle": "Fresh bananas",
      "price": "₹60"
    },
    {
      "image": "assets/images/5.jpg",
      "title": "Avocado",
      "subtitle": "Healthy avocado",
      "price": "₹140"
    },
    {
      "image": "assets/images/6.jpg",
      "title": "Apple",
      "subtitle": "Fresh apple",
      "price": "₹100"
    },
    {
      "image": "assets/images/7.jpg",
      "title": "Orange",
      "subtitle": "Sweet orange",
      "price": "₹80"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// 🔥 STACK USE
        body: Stack(
          children: [

            /// 🔽 MAIN CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const DeliverAddressWidget(
                    ),

                    Divider(color: const Color(0xffceaef3).withOpacity(0.2)),

                    VendorList(vendors: vendors),

                    const SizedBox(height: 10),
                    FruitsList(fruits: fruits),
                    const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Product Found 135",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showFilterBottomSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.filter_list,
                                  size: 16, color: Colors.purple),
                              SizedBox(width: 5),
                              Text(
                                "Filter",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                    const SizedBox(height: 10),

                    ProductGrid(
                      products: products,
                      quantities: quantities,

                      onAdd: (index) {
                        setState(() {
                          quantities[index] = 1;
                        });
                      },

                      onIncrease: (index) {
                        setState(() {
                          quantities[index]++;
                        });
                      },

                      onDecrease: (index) {
                        setState(() {
                          if (quantities[index] > 0) {
                            quantities[index]--;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// 🔥 FLOATING CART (OVERLAY)
            if (totalItems > 0)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 🔥 responsive width
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0XFF9333ea),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "View Cart ($totalItems items)",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    String selectedSort = "Popularity";
    List<String> selectedCategories = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Filters",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                selectedSort = "Popularity";
                                selectedCategories.clear();
                              });
                            },
                            child: const Text(
                              "Reset",
                              style: TextStyle(color: Colors.purple),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      /// Sort By Section
                      const Text(
                        "Sort By",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      _buildSortOption(
                        title: "Popularity",
                        value: "Popularity",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setModalState(() {
                            selectedSort = value!;
                          });
                        },
                      ),
                      _buildSortOption(
                        title: "Price Low → High",
                        value: "LowToHigh",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setModalState(() {
                            selectedSort = value!;
                          });
                        },
                      ),
                      _buildSortOption(
                        title: "Price High → Low",
                        value: "HighToLow",
                        groupValue: selectedSort,
                        onChanged: (value) {
                          setModalState(() {
                            selectedSort = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      /// Category Section
                      const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        children: [
                          _buildCategoryChip(
                              "Fruits", selectedCategories, setModalState),
                          _buildCategoryChip(
                              "Vegetables", selectedCategories, setModalState),
                          _buildCategoryChip(
                              "Organic", selectedCategories, setModalState),
                          _buildCategoryChip(
                              "Seasonal", selectedCategories, setModalState),
                        ],
                      ),

                      const SizedBox(height: 25),

                      /// Apply Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.purple,
                          ),
                          child: const Text(
                            "Apply Filters",
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Colors.purple,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildCategoryChip(
      String label,
      List<String> selectedCategories,
      StateSetter setModalState,
      ) {
    final isSelected = selectedCategories.contains(label);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.purple.withOpacity(0.2),
      checkmarkColor: Colors.purple,
      onSelected: (selected) {
        setModalState(() {
          if (selected) {
            selectedCategories.add(label);
          } else {
            selectedCategories.remove(label);
          }
        });
      },
    );
  }
}
