import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../provider/vendor_category_provider.dart';
import '../../provider/vendor_provider.dart';
import '../../widgets/vender_card_component.dart';

import '../vendorCategory/vendor_category_list.dart';
import '../../widgets/vendor_category_item_widget.dart';

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

 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().fetchVendorCategory(widget.categoryId, widget.subCategoryId);
     
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

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(AppSize.width(0.04)),
                        itemCount: provider.vendorCategory.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSize.width(0.02),
                          mainAxisSpacing: AppSize.height(0.015),
                          childAspectRatio: 1.4,
                        ),
                        itemBuilder: (context, index) {
                          final vendor = provider.vendorCategory[index];
                          return VendorCard(
                            title: vendor.businessName,
                            backgroundImage: vendor.kycDetail?.shopPhoto?.url ?? "",
                            logoImage: vendor.kycDetail?.ownerPhoto?.url ?? "",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorCategoryList(
                                    categoryId: widget.categoryId,
                                    subCategoryId: widget.subCategoryId,
                                    vendorId: vendor.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                            
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
