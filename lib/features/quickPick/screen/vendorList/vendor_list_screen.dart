import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/model/user_address_model.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';
import 'package:resheragroup/core/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resheragroup/features/quickPick/provider/view_cart_list_provider.dart';
import 'package:resheragroup/features/quickPick/widgets/cart_widgets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../widgets/custom_search_widget.dart';
import '../../provider/vendor_category_provider.dart';
import '../../provider/vendor_provider.dart';
import '../../widgets/vender_card_component.dart';

import '../checkout/check_out_screen.dart';
import '../vendorCategory/vendor_category_list.dart';
import '../../widgets/vendor_category_item_widget.dart';

class VendorListScreen extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String categoryName;

  const VendorListScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
  });

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  String currentLocation = "Fetching location...";
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().fetchVendorCategory(widget.categoryId, widget.subCategoryId);
    });
  }

  Future<void> _loadInitialData() async {
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
                const Text(
                  "Vendor List",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
          // Padding(
          //   padding:  EdgeInsets.only(right:AppSize.width(0.04)),
          //   child: Container(
          //     height: AppSize.width(0.10),
          //     width: AppSize.width(0.10),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       shape: BoxShape.circle,
          //     ),
          //
          //     child: IconButton(
          //       icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const CheckOutScreen()),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: AppSize.width(0.04), right: AppSize.width(0.04), bottom: AppSize.width(0.02)),
                color: const Color(0xFF7B2CBF),
                child: CustomSearchWidget(
                  onSearch: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  hintText: 'Search vendors...',
                ),
              ),
              Expanded(
                child: Consumer<VendorProvider>(
                  builder: (context, provider, child){
    
                    if (provider.isLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSize.width(0.04),
                            vertical: AppSize.height(0.02)),
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppSize.height(0.02)),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: AppSize.height(0.22),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(height: 15, width: 150, color: Colors.white),
                                    const SizedBox(height: 5),
                                    Container(height: 12, width: 200, color: Colors.white),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
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
                              onPressed: () => provider.fetchVendorCategory(widget.categoryId,widget.subCategoryId,),
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
    
                    final filteredVendors = provider.vendorCategory.where((vendor) {
                      return vendor.businessName.toLowerCase().contains(_searchQuery);
                    }).toList();
    
                    if (filteredVendors.isEmpty) {
                      return const Center(
                        child: Text(
                          "no search item found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
    
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(AppSize.width(0.04)),
                            itemCount: filteredVendors.length,
                            itemBuilder: (context, index) {
                              final vendor = filteredVendors[index];
                              return VendorCard(
                                logo: vendor.kycDetail?.ownerPhoto?.url ?? "",
                                title: vendor.businessName,
                                vendorId: vendor.user?.vendorId ??"",
                                backgroundImage: vendor.kycDetail?.shopPhoto?.url ?? "",
                                address: vendor.user?.mobile ?? "",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VendorCategoryList(
                                        categoryId: widget.categoryId,
                                        subCategoryId: widget.subCategoryId,
                                        vendorId: vendor.id,
                                        categoryName: widget.categoryName,
                                        bannerLogo: vendor.kycDetail?.ownerPhoto?.url ?? "",
                                        vendorName: vendor.businessName,
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
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Consumer<ViewCartListProvider>(
                builder: (context, cartProvider, child) {
                  return FloatingCartBar(
                    itemCount: cartProvider.totalItems,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
