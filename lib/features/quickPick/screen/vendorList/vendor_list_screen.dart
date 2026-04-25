import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../widgets/custom_search_widget.dart';
import '../../provider/vendor_provider.dart';
import '../../widgets/vender_card_component.dart';

class VendorListScreen extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;


  const VendorListScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,



  });

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  // Static list of vendors
  final List<Map<String, String>> vendors = [
    {
      "name": "Spencer",
      "background": "https://img.freepik.com/free-photo/grocery-store-shelves-with-vegetables-fruits_23-2148286241.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/en/thumb/5/5e/Spencer%27s_Retail_logo.svg/1200px-Spencer%27s_Retail_logo.svg.png",
    },
    {
      "name": "BigBasket",
      "background": "https://img.freepik.com/free-photo/healthy-food-vegetables-fruits-market_23-2148171638.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/2/23/Bigbasket_logo.png",
    },
    {
      "name": "More Retail",
      "background": "https://img.freepik.com/free-photo/supermarket-aisle-with-empty-shopping-cart_23-2148286240.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/en/thumb/4/4b/More_Retail_Logo.svg/1200px-More_Retail_Logo.svg.png",
    },
    {
      "name": "Reliance Fresh",
      "background": "https://img.freepik.com/free-photo/fresh-vegetables-market-stall_23-2148171644.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Reliance_Fresh_Logo.svg/2560px-Reliance_Fresh_Logo.svg.png",
    },
    {
      "name": "Blinkit",
      "background": "https://img.freepik.com/free-photo/delivery-man-carrying-paper-bag-food_23-2148560370.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/d/d3/Blinkit_logo.png",
    },
    {
      "name": "Zepto",
      "background": "https://img.freepik.com/free-photo/courier-riding-scooter-deliver-food_23-2148834921.jpg",
      "logo": "https://upload.wikimedia.org/wikipedia/en/thumb/7/7d/Zepto_Logo.png/640px-Zepto_Logo.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().fetchVendorCategory(widget.categoryId,widget.subCategoryId);
    });
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
        title: Text(
          "Vendor List",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: Consumer<VendorProvider>(
              builder: (context, provider, child){

                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => provider.fetchVendorCategory(widget.categoryId,widget.subCategoryId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B2CBF),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.vendorCategory.isEmpty) {
                  return const Center(child: Text("No Vendor List found"));
                }


                return GridView.builder(
                  padding: EdgeInsets.all(AppSize.width(0.04)),
                  itemCount: provider.vendorCategory.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSize.width(0.03),
                    mainAxisSpacing: AppSize.height(0.02),
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final vendor = provider.vendorCategory[index];
                    return VendorCard(
                      title: vendor.businessName,
                      backgroundImage: vendor.kycDetail?.shopPhoto?.url??"",
                      logoImage: vendor.kycDetail?.ownerPhoto?.url??"",
                      onTap: () {
                        debugPrint("Tapped on ${vendor.businessName}");
                        // Navigate to Items screen if needed
                      },
                    );
                  },
                );
              },

            ),
          ),
        ],
      ),
    );
  }
}
