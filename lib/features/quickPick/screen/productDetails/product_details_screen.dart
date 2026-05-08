import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/product_details_provider.dart';
import '../../provider/cart_provider.dart';
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
  String? cachedAddress;
  int _cartCount = 0;
  Variant? _selectedVariant;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsProvider>().fetchProductDetails(
        businessCategoryId: widget.businessCategoryId,
        businessSubCategoryId: widget.businessSubCategoryId,
        categoryId: widget.categoryId,
        productId: widget.productId,
        businessId: widget.businessId,
      );
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
        title: Column(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                  );
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
                  if (_cartCount > 0)
                    FloatingCartBar(
                      itemCount: _cartCount,
                      onTap: () async {
                        if (_selectedVariant == null) return;

                        final cartProvider = context.read<CartProvider>();
                        final success = await cartProvider.addToCart(
                          productId: widget.productId,
                          businessCategoryId: widget.businessCategoryId,
                          variantId: _selectedVariant!.variantId ?? "",
                          quantity: _cartCount,
                          attributes: _selectedVariant!.attributes ?? [],
                        );
                        print("success=$success");

                        if (success && mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckOutScreen()),
                          );
                        } else if (mounted && cartProvider.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(cartProvider.errorMessage!)),
                          );
                        }
                      },
                    ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    color: Colors.white,
                    child: CartCounterWidget(
                      initialLabel: "Buy Now",
                      onCountChanged: (count) {
                        setState(() {
                          _cartCount = count;
                        });
                      },
                    ),
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
