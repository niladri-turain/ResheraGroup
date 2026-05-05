import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/product_details_provider.dart';
import '../../widgets/product_details_item_widget.dart';
import '../checkout/check_out_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String businessCategoryId;
  final String businessSubCategoryId;
  final String categoryId;
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.businessCategoryId,
    required this.businessSubCategoryId,
    required this.categoryId,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? cachedAddress;

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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
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
      body: Consumer<ProductDetailsProvider>(
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

          return ProductDetailsItemWidget(product: provider.productDetails!);
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: const BorderSide(color: Color(0xFF7B2CBF)),
                ),
                child: const Text("Add to Cart", style: TextStyle(color: Color(0xFF7B2CBF))),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Buy Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
