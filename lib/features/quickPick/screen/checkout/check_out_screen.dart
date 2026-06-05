import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';
import 'package:resheragroup/features/quickPick/provider/order_provider.dart';
import 'package:resheragroup/features/quickPick/screen/category/quick_pick_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import '../../../login/screen/login_screen.dart';
import '../../provider/update_cart_provider.dart';
import '../../provider/delete_cart_provider.dart';
import '../../provider/cancel_all_cart_provider.dart';
import '../../provider/view_cart_list_provider.dart';
import '../../widgets/address_selection_sheet.dart';

import '../../../login/provider/login_provider.dart';
import '../../widgets/checkout_item_widget.dart';
import '../itemOrder/item_order_screen.dart';

class CheckOutScreen extends StatefulWidget {
  final String? vendorName;
  final String? vendorKycId;
  const CheckOutScreen({super.key, this.vendorName, this.vendorKycId});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String selectedPayment = 'COD';
  String? cachedAddress;
  String? billAddress;

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

    _loadBillingAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewCartListProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(AppSize.width(0.02)),
          child: CircleAvatar(
            backgroundColor: const Color(0XFF9333ea),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: AppSize.width(0.05)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Consumer<UserAddressProvider>(
          builder: (context, addressProvider, child) {
            final displayAddress = addressProvider.selectedAddress?.address ?? addressProvider.guestLocation;
            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddressSelectionSheet(
                    selectedAddress: addressProvider.selectedAddress,
                    onAddressSelected: (address) {
                      addressProvider.setSelectedAddress(address);
                    },
                  ),
                );
              },
              child: Column(
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

                  if (displayAddress != null)
                    Text(
                      displayAddress,
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
            );
          },
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
                  SizedBox(height: AppSize.height(0.025)),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.width(0.08),
                        vertical: AppSize.height(0.015),
                      ),
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

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSize.width(0.04),
                    AppSize.height(0.02),
                    AppSize.width(0.04),
                    AppSize.height(0.12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(AppSize.width(0.01)),
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
                      SizedBox(height: AppSize.height(0.01)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(AppSize.width(0.04)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Summary',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: AppSize.height(0.02)),
                            _buildBillRow(
                              icon: Icons.receipt_long_outlined,
                              label: 'Items total',
                              price: '₹${totalAmount.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: AppSize.height(0.015)),
                            _buildBillRow(
                              icon: Icons.shopping_bag_outlined,
                              label: 'Handling charge',
                              price: '₹0',
                            ),
                            SizedBox(height: AppSize.height(0.015)),
                            _buildBillRow(
                              icon: Icons.pedal_bike,
                              label: 'Delivery charge',
                              price: '0',
                            ),
                            SizedBox(height: AppSize.height(0.015)),
                            SizedBox(height: AppSize.height(0.02)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Items - ${cartData.totalItems ?? cartData.data!.length}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Grand total ₹${(totalAmount).toStringAsFixed(2)}',
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
                      SizedBox(height: AppSize.height(0.01)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(AppSize.width(0.04)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vendor Details',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: AppSize.height(0.02)),
                            Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: AppSize.width(0.1),
                                      height: AppSize.width(0.1),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4B70F5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        color: Colors.white,
                                        size: AppSize.width(0.05),
                                      ),
                                    ),
                                    SizedBox(width: AppSize.width(0.03)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Vendor Id: ${widget.vendorKycId ?? ''}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: AppSize.height(0.001)),
                                          Text(
                                            "vendor name: ${widget.vendorName ?? ''}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            billAddress ?? "",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: AppSize.height(0.001)),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.01)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(AppSize.width(0.04)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Billing Address',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: AppSize.height(0.02)),
                            Consumer<LoginProvider>(
                              builder: (context, loginProvider, child) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: AppSize.width(0.1),
                                      height: AppSize.width(0.1),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4B70F5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        color: Colors.white,
                                        size: AppSize.width(0.05),
                                      ),
                                    ),
                                    SizedBox(width: AppSize.width(0.03)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            billAddress ?? "",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: AppSize.height(0.005)),

                                          Text(
                                            "Phone: ${loginProvider.userPhone ?? ''}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: AppSize.height(0.005)),
                                          Text(
                                            "Email: ${loginProvider.userEmail ?? ''}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.01)),
                      Consumer<UserAddressProvider>(
                        builder: (context, addressProvider, child) {
                          final shippingAddr = addressProvider.selectedAddress;
                          final displayShippingAddress = shippingAddr?.address ?? addressProvider.guestLocation ?? "";
                          final phone = shippingAddr?.phone ?? context.read<LoginProvider>().userPhone ?? '';
                          final email = context.read<LoginProvider>().userEmail ?? '';

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.all(AppSize.width(0.04)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Shipping Address',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => AddressSelectionSheet(
                                            selectedAddress: addressProvider.selectedAddress,
                                            onAddressSelected: (address) {
                                              addressProvider.setSelectedAddress(address);
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.green,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                                          child: Text(
                                            "Change Address",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: AppSize.height(0.02)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: AppSize.width(0.1),
                                      height: AppSize.width(0.1),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4B70F5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.local_shipping_outlined,
                                        color: Colors.white,
                                        size: AppSize.width(0.05),
                                      ),
                                    ),
                                    SizedBox(width: AppSize.width(0.03)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayShippingAddress,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: AppSize.height(0.005)),
                                          Text(
                                            "Phone: $phone",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                            ),
                                          ),
                                          if (email.isNotEmpty) ...[
                                            SizedBox(height: AppSize.height(0.005)),
                                            Text(
                                              "Email: $email",
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSize.height(0.01)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(AppSize.width(0.04)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Method',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: AppSize.height(0.005)),
                            InkWell(
                              onTap: () => setState(() => selectedPayment = 'COD'),
                              child: SizedBox(
                                height: AppSize.height(0.04),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'COD',
                                      groupValue: selectedPayment,
                                      activeColor: const Color(0xFF7B2CBF),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPayment = value!;
                                        });
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    ),
                                    SizedBox(width: AppSize.width(0.02)),
                                    const Text('Cash on Delivery (COD)'),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => selectedPayment = 'Online'),
                              child: SizedBox(
                                height: AppSize.height(0.04),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Online',
                                      groupValue: selectedPayment,
                                      activeColor: const Color(0xFF7B2CBF),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPayment = value!;
                                        });
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    ),
                                    SizedBox(width: AppSize.width(0.02)),
                                    const Text('Online Payment'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSize.height(0.01)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(0.04),
                    vertical: AppSize.height(0.02),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: AppSize.height(0.06),
                          child: Consumer<CancelAllCartProvider>(
                            builder: (context, cancelProvider, child) {
                              return OutlinedButton(
                                onPressed: cancelProvider.isLoading
                                    ? null
                                    : () async {
                                        final success = await cancelProvider.cancelCart();
                                        if (success) {
                                          if (mounted) {
                                            context.read<ViewCartListProvider>().clearCartLocal();
                                            context.read<ViewCartListProvider>().fetchCart();
                                          }
                                        } else {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(cancelProvider.errorMessage ?? "Failed to cancel cart")),
                                            );
                                          }
                                        }
                                      },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF7B2CBF)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                child: cancelProvider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7B2CBF)),
                                      )
                                    : const Text(
                                        "Cancel Cart",
                                        style: TextStyle(
                                          color: Color(0xFF7B2CBF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: AppSize.width(0.03)),
                      Expanded(
                        child: SizedBox(
                          height: AppSize.height(0.06),
                          child: ElevatedButton(
                            onPressed: () async {
                              final addressProvider = context.read<UserAddressProvider>();
                              final orderProvider = context.read<OrderProvider>();

                              double currentTotal = 0;
                              if (cartData != null && cartData.data != null) {
                                for (var item in cartData.data!) {
                                  final price = double.tryParse(item.product?.finalPrice.toString() ?? '0') ?? 0;
                                  currentTotal += price * (item.quantity ?? 0);
                                }
                              }

                              final success = await orderProvider.placeOrder(
                                itemsTotal: currentTotal,
                                grandTotal: currentTotal,
                                discountAmount: 0,
                                paymentMethod: selectedPayment,
                                billing: addressProvider.addressModel?.data?.billing,
                                shipping: addressProvider.selectedAddress,
                              );

                              if (success) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Order placed successfully")),
                                  );

                                  context.read<ViewCartListProvider>().clearCartLocal();

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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B2CBF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Proceed (${cartData.totalItems ?? 0} Items)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSize.width(0.04),
            AppSize.height(0.02),
            AppSize.width(0.04),
            AppSize.height(0.12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Items", style: TextStyle(backgroundColor: Colors.white)),
              SizedBox(height: AppSize.height(0.015)),
              SizedBox(
                height: AppSize.height(0.13),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (context, index) => SizedBox(width: AppSize.width(0.03)),
                  itemBuilder: (context, index) => Container(
                    width: AppSize.width(0.23),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(AppSize.width(0.02)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: AppSize.width(0.1),
                          height: AppSize.width(0.1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: AppSize.height(0.01)),
                        Container(width: AppSize.width(0.15), height: AppSize.height(0.012), color: Colors.white),
                        SizedBox(height: AppSize.height(0.005)),
                        Container(width: AppSize.width(0.08), height: AppSize.height(0.01), color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSize.height(0.025)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(AppSize.width(0.03)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: AppSize.width(0.2), height: AppSize.height(0.016), color: Colors.white),
                    SizedBox(height: AppSize.height(0.015)),
                    ...List.generate(
                      2,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.height(0.005)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: AppSize.width(0.15), height: AppSize.height(0.012), color: Colors.white),
                            Container(width: AppSize.width(0.1), height: AppSize.height(0.012), color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: AppSize.width(0.15), height: AppSize.height(0.014), color: Colors.white),
                        Container(width: AppSize.width(0.2), height: AppSize.height(0.014), color: Colors.white),
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
        Icon(icon, size: AppSize.width(0.045), color: Colors.grey),
        SizedBox(width: AppSize.width(0.02)),
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
        if (oldPrice != null) SizedBox(width: AppSize.width(0.01)),
        Text(
          price,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _loadBillingAddress() async {
    final addressProvider = context.read<UserAddressProvider>();
    final billingAddresses = addressProvider.addressModel?.data?.billing;

    if (billingAddresses != null && billingAddresses.address != null) {
      if (mounted) {
        setState(() {
          billAddress =
          "${billingAddresses.address ?? ""}, ${billingAddresses.city?.name ??
              ""}, ${billingAddresses.pincode ?? ""},${billingAddresses.state?.name ??
              ""}";
        });
      }
    }
  }
}
