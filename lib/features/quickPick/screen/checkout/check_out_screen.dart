import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/provider/order_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/service/location_service.dart';
import '../../provider/update_cart_provider.dart';
import '../../provider/delete_cart_provider.dart';
import '../../provider/view_cart_list_provider.dart';
import '../../widgets/cart_widgets.dart';
import '../../widgets/checkout_item_widget.dart';
import '../itemOrder/item_order_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String selectedPayment = 'UPI Pay';
  String? cachedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewCartListProvider>().fetchCart();
    });
  }
  Future<void> _loadAddress() async {
    final address = await LocationService.getCachedAddress();
    if (mounted) {
      setState(() {
        cachedAddress = address;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0XFF9333ea),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.width(0.045),
              ),
            ),
            if (cachedAddress != null)
              Text(
                cachedAddress!,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: AppSize.width(0.032),
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
      body: Consumer<ViewCartListProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.cartData == null) {
            return _buildSkeleton();
          }

          if (provider.errorMessage != null && provider.cartData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  ElevatedButton(
                    onPressed: () => provider.fetchCart(),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }

          final cartData = provider.cartData;
          if (cartData == null || cartData.data == null || cartData.data!.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          final updateProvider = context.watch<UpdateCartProvider>();
          final deleteProvider = context.watch<DeleteCartProvider>();

          double totalAmount = 0;
          for (var item in cartData.data!) {
            final price = double.tryParse(item.product?.finalPrice.toString() ?? '0') ?? 0;
            totalAmount += price * (item.quantity ?? 0);
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Items Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartData.data!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = cartData.data![index];
                        final attributes = item.attributes
                                ?.map((e) => "${e.attributeName}: ${e.attributeValue}")
                                .join(", ") ??
                            "";

                        return Stack(
                          children: [
                            CheckoutItemWidget(
                              image: item.image ?? "",
                              title: item.productName ?? "",
                              subtitle: attributes,
                              price: item.product?.finalPrice.toString() ?? "0",
                              quantity: item.quantity ?? 1,
                              onIncrease: (updateProvider.isUpdating || deleteProvider.isDeleting)
                                  ? () {}
                                  : () async {
                                      final success = await updateProvider.updateCart(
                                        cartId: item.id ?? "",
                                        quantity: (item.quantity ?? 0) + 1,
                                      );
                                      if (success) {
                                        // if (mounted) {
                                        //   ScaffoldMessenger.of(context).showSnackBar(
                                        //     SnackBar(
                                        //       backgroundColor: const Color(0xFF7B2CBF),
                                        //       behavior: SnackBarBehavior.floating,
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius: BorderRadius.circular(10),
                                        //       ),
                                        //       content: const Text(
                                        //         'Cart updated successfully',
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontWeight: FontWeight.w500,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                          provider.fetchCart(showLoader: false);
                                      }
                                    },
                              onDecrease: (updateProvider.isUpdating || deleteProvider.isDeleting)
                                  ? () {}
                                  : () async {
                                      if ((item.quantity ?? 0) > 1) {
                                        final success = await updateProvider.updateCart(
                                          cartId: item.id ?? "",
                                          quantity: (item.quantity ?? 0) - 1,
                                        );
                                        if (success) {
                                          // if (mounted) {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     SnackBar(
                                          //       backgroundColor: const Color(0xFF7B2CBF),
                                          //       behavior: SnackBarBehavior.floating,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(10),
                                          //       ),
                                          //       content: const Text(
                                          //         'Cart updated successfully',
                                          //         style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight: FontWeight.w500,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   );
                                          // }
                                          provider.fetchCart(showLoader: false);
                                        }
                                      } else if ((item.quantity ?? 0) == 1) {
                                        final success = await deleteProvider.deleteCart(
                                          cartId: item.id ?? "",
                                        );
                                        if (success) {
                                          // if (mounted) {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     SnackBar(
                                          //       backgroundColor: const Color(0xFF7B2CBF),
                                          //       behavior: SnackBarBehavior.floating,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(10),
                                          //       ),
                                          //       content: const Text(
                                          //         'item delete successfully',
                                          //         style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight: FontWeight.w500,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   );
                                          // }
                                          provider.fetchCart(showLoader: false);
                                        }
                                      }
                                    },
                            ),
                            // if (updateProvider.isUpdating || deleteProvider.isDeleting)
                            //   Positioned.fill(
                            //     child: Container(
                            //       color: Colors.white.withOpacity(0.3),
                            //       child: const Center(
                            //         child: SizedBox(
                            //           width: 20,
                            //           height: 20,
                            //           child: CircularProgressIndicator(
                            //             strokeWidth: 2,
                            //             valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF9333ea)),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bill Details Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bill details',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        _buildBillRow(
                          icon: Icons.receipt_long_outlined,
                          label: 'Items total',
                          price: '₹${totalAmount.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 12),
                        _buildBillRow(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Handling charge',
                          price: '₹5',
                        ),
                        const SizedBox(height: 12),
                        _buildBillRow(
                          icon: Icons.pedal_bike,
                          label: 'Delivery charge',
                          price: '₹30',
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Shop for ₹50 more to get FREE delivery',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items - ${cartData.totalItems ?? cartData.data!.length}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Grand total ₹${(totalAmount + 5 + 30).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0XFF9333ea),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<ViewCartListProvider>(
        builder: (context, provider, child) {
          final cartData = provider.cartData;
          if (cartData == null || cartData.data == null || cartData.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          int totalItems = 0;
          for (var item in cartData.data!) {
            totalItems += (item.quantity ?? 0);
          }

          if (totalItems == 0) return const SizedBox.shrink();

          return FloatingCartBar(
            itemCount: cartData.totalItems??0,
            label: 'Proceed to',

              onTap: () async {
                final success = await context.read<OrderProvider>().placeOrder();
                if (success) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Order placed successfully")),
                    );
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ItemOrderScreen(),
                      ),
                    );
                    if (mounted) {
                      context.read<ViewCartListProvider>().fetchCart();
                    }
                  }
                } else {
                  if (mounted) {
                    final error = context.read<OrderProvider>().errorMessage;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error ?? "Failed to place order")),
                    );
                  }
                }
              },

          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //     boxShadow: [
      //       BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Row(
      //         children: [
      //           Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: Colors.purple.shade50,
      //               borderRadius: BorderRadius.circular(8),
      //             ),
      //             child: const Icon(Icons.home_outlined, color: Color(0XFF9333ea)),
      //           ),
      //           const SizedBox(width: 12),
      //           const Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   'Delivering to Home',
      //                   style: TextStyle(fontWeight: FontWeight.bold),
      //                 ),
      //                 Text(
      //                   'Floor 1st, 9F Abdul biryani center,...',
      //                   style: TextStyle(color: Colors.grey, fontSize: 12),
      //                   overflow: TextOverflow.ellipsis,
      //                 ),
      //               ],
      //             ),
      //           ),
      //           TextButton(
      //             onPressed: () {},
      //             child: const Text(
      //               'Change',
      //               style: TextStyle(color: Colors.green),
      //             ),
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 16),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text('Paying Type', style: TextStyle(fontSize: 12, color: Colors.grey)),
      //                 Container(
      //                   padding: const EdgeInsets.symmetric(horizontal: 12),
      //                   decoration: BoxDecoration(
      //                     border: Border.all(color: Colors.grey.shade300),
      //                     borderRadius: BorderRadius.circular(8),
      //                   ),
      //                   child: DropdownButtonHideUnderline(
      //                     child: DropdownButton<String>(
      //                       value: selectedPayment,
      //                       isExpanded: true,
      //                       items: ['UPI Pay', 'Cash on Delivery'].map((String value) {
      //                         return DropdownMenuItem<String>(
      //                           value: value,
      //                           child: Text(value),
      //                         );
      //                       }).toList(),
      //                       onChanged: (newValue) {
      //                         setState(() {
      //                           selectedPayment = newValue!;
      //                         });
      //                       },
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(width: 16),
      //           Expanded(
      //             child: ElevatedButton(
      //               onPressed: () {},
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: const Color(0XFF9333ea),
      //                 padding: const EdgeInsets.symmetric(vertical: 16),
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //               ),
      //               child: const Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Text(
      //                     'Place Order',
      //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //                   ),
      //                   Icon(Icons.chevron_right, color: Colors.white),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Items Section Skeleton (Small Horizontal List of Column Containers)
              const Text("Items", style: TextStyle(backgroundColor: Colors.white)),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => Container(
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(width: 60, height: 10, color: Colors.white),
                        const SizedBox(height: 4),
                        Container(width: 30, height: 8, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Bill Details Section Skeleton (Slimmer)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 14, color: Colors.white),
                    const SizedBox(height: 12),
                    ...List.generate(
                      2,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 60, height: 10, color: Colors.white),
                            Container(width: 40, height: 10, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 60, height: 12, color: Colors.white),
                        Container(width: 80, height: 12, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow({
    required IconData icon,
    required String label,
    String? oldPrice,
    required String price,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.black87)),
        const Spacer(),
        if (oldPrice != null)
          Text(
            oldPrice,
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
          ),
        if (oldPrice != null) const SizedBox(width: 4),
        Text(
          price,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
