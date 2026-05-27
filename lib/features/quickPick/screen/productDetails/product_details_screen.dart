import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/model/user_address_model.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';
import 'package:resheragroup/main_screen.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../login/screen/login_screen.dart';
import '../../provider/product_details_provider.dart';
import '../../provider/cart_provider.dart';
import '../../provider/view_cart_list_provider.dart';
import '../../model/product_details_model.dart';
import '../../widgets/cart_widgets.dart';
import '../../widgets/product_details_item_widget.dart';
import '../checkout/check_out_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String businessCategoryId;
  final String businessSubCategoryId;
  final String categoryId;
  final String productId;
  final String businessId;

  const ProductDetailsScreen({
    super.key,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.categoryId,
    required this.productId,
    required  this.businessId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String currentLocation = "Fetching location...";
  Variant? _selectedVariant;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsProvider>().fetchProductDetails(
        businessCategoryId: widget.businessCategoryId,
        businessSubCategoryId: widget.businessSubCategoryId,
        categoryId: widget.categoryId,
        productId: widget.productId,
        businessId: widget.businessId,
      );
      context.read<ViewCartListProvider>().fetchCart(showLoader: false);
    });
  }

  Future<void> _fetchInitialData() async {
    final prefService = sl<SharedPrefService>();
    final token = await prefService.getToken();

    if (token != null && token.isNotEmpty) {
      final addressProvider = context.read<UserAddressProvider>();
      if (addressProvider.addressModel == null) {
        await addressProvider.fetchUserAddresses(token);
      }

      final addresses = addressProvider.addressModel?.data?.shipping;
      if (addresses != null && addresses.isNotEmpty && addressProvider.selectedAddress == null) {
        addressProvider.setSelectedAddress(addresses.first);
      }
    }

    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    String address = await LocationService.getCurrentAddress();
    if (mounted) {
      setState(() {
        currentLocation = address;
      });
    }
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressSelectionSheet(
          selectedAddress: context.read<UserAddressProvider>().selectedAddress,
          onAddressSelected: (addr) {
            context.read<UserAddressProvider>().setSelectedAddress(addr);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer2<LoginProvider, UserAddressProvider>(
          builder: (context, loginProvider, addressProvider, child) {
            String displayLocation = currentLocation;
            if (addressProvider.selectedAddress != null) {
              displayLocation = addressProvider.selectedAddress!.address ?? "";
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.width(0.045),
                  ),
                ),
                GestureDetector(
                  onTap: loginProvider.userName != null ? _showAddressBottomSheet : null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(
                      displayLocation,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: AppSize.width(0.032),
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSize.width(0.04)),
            child: Container(
              height: AppSize.width(0.10),
              width: AppSize.width(0.10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () async {
                  final cartListProvider = context.read<ViewCartListProvider>();
                  final localItems = Map.from(cartListProvider.localCart);

                  if (localItems.isNotEmpty) {
                    final cartProvider = context.read<CartProvider>();
                    for (var entry in localItems.entries) {
                      final item = entry.value;
                      await cartProvider.addToCart(
                        productId: item['productId'],
                        businessCategoryId: item['businessCategoryId'],
                        variantId: item['variantId'],
                        quantity: item['quantity'],
                        attributes: (item['attributes'] as List).map((a) => Attribute(
                          attributeId: a['attribute_id'],
                          attributeName: a['attribute_name'],
                          valueId: a['value_id'],
                          value: a['value'],
                        )).toList(),
                      );
                    }
                    cartListProvider.clearLocalCart();
                  }

                  if (!mounted) return;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                  );
                  if (mounted) {
                    context.read<ViewCartListProvider>().fetchCart(showLoader: false);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProductDetailsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              if (provider.productDetails == null) {
                return const Center(child: Text("Product not found"));
              }

              return ProductDetailsItemWidget(
                product: provider.productDetails!,
                onVariantChanged: (variant) {
                  setState(() {
                    _selectedVariant = variant;
                  });
                },
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                  stops: const [0, 0.2, 1],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer2<ViewCartListProvider, LoginProvider>(
                    builder: (context, cartListProvider, loginProvider, child) {
                      int totalUniqueDisplay = cartListProvider.totalUniqueItems;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (totalUniqueDisplay > 0)
                            FloatingCartBar(
                              itemCount: totalUniqueDisplay,
                              label: "View cart",
                              onTap: () async {
                                if (loginProvider.userName == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please login to proceed")),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                        onLoginSuccess: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final localItems = Map.from(cartListProvider.localCart);
                                if (localItems.isNotEmpty) {
                                  final cartProvider = context.read<CartProvider>();
                                  for (var entry in localItems.entries) {
                                    final item = entry.value;
                                    await cartProvider.addToCart(
                                      productId: item['productId'],
                                      businessCategoryId: item['businessCategoryId'],
                                      variantId: item['variantId'],
                                      quantity: item['quantity'],
                                      attributes: (item['attributes'] as List).map((a) => Attribute(
                                        attributeId: a['attribute_id'],
                                        attributeName: a['attribute_name'],
                                        valueId: a['value_id'],
                                        value: a['value'],
                                      )).toList(),
                                    );
                                  }
                                  cartListProvider.clearLocalCart();
                                }

                                if (!mounted) return;

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CheckOutScreen(),
                                  ),
                                );

                                if (mounted) {
                                  context.read<ViewCartListProvider>().fetchCart(showLoader: false);
                                }
                              },
                            ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            color: Colors.white,
                            child: CartCounterWidget(
                              initialCount: cartListProvider.getLocalQuantity(widget.productId),
                              initialLabel: "Add to cart",
                              onCountChanged: (count) {
                                if (loginProvider.userName == null && count > 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please login to add items to cart")),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                        onLoginSuccess: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                
                                if (_selectedVariant != null) {
                                  cartListProvider.updateLocalCartItem(
                                    productId: widget.productId,
                                    businessCategoryId: widget.businessCategoryId,
                                    variantId: _selectedVariant!.variantId ?? "",
                                    quantity: count,
                                    attributes: _selectedVariant!.attributes ?? [],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
