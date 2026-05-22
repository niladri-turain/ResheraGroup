import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/provider/order_provider.dart';
import 'package:resheragroup/features/quickPick/screen/category/quick_pick_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/service/location_service.dart';
import '../../../../main_screen.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import '../../../login/screen/login_screen.dart';
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
    _checkLoginAndLoadData();
  }

  Future<void> _checkLoginAndLoadData() async {
    final prefService = sl<SharedPrefService>();
    final token = await prefService.getToken();

    if (token == null || token.isEmpty) {
      if (mounted) {
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                onLoginSuccess: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                  );
                },
              ),
            ),
          );
        });
      }
      return;
    }

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const QuickPickScreen()),

                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2CBF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue Shopping",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
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

                        return CheckoutItemWidget(
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
                                      provider.fetchCart(showLoader: false);
                                    }
                                  } else if ((item.quantity ?? 0) == 1) {
                                    final success = await deleteProvider.deleteCart(
                                      cartId: item.id ?? "",
                                    );
                                    if (success) {
                                      provider.fetchCart(showLoader: false);
                                    }
                                  }
                                },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
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
            itemCount: cartData.totalItems ?? 0,
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
