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
import 'package:resheragroup/main_screen.dart';

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

  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool showDot = false,
    required bool isTablet,
  }) {
    double size = isTablet ? 55 : 40;
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isTablet ? 30 : 22,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: isTablet ? 90 : 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: isTablet ? 25 : 24),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Vendor List",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 24 : 18,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: loginProvider.userName != null ? _showAddressBottomSheet : null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: isTablet ? 20 : 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          displayLocation,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet ? 20 : 12,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: isTablet ? 24 : 16),
            child: _circleIcon(
              icon: Icons.person_outline,
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(initialIndex: 3),
                  ),
                  (route) => false,
                );
              },
              isTablet: isTablet,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 24 : 16,
                  isTablet ? 4 : 0,
                  isTablet ? 24 : 16,
                  isTablet ? 20 : 12,
                ),
                color: const Color(0xFF7B2CBF),
                child: CustomSearchWidget(
                  height: isTablet ? 60 : 45,
                  onSearch: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  hintText: 'Search vendors...',
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<VendorProvider>().fetchVendorCategory(widget.categoryId, widget.subCategoryId);
                  },
                  child: Consumer<VendorProvider>(
                    builder: (context, provider, child) {
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
                        return ListView(
                          children: [
                            SizedBox(height: AppSize.height(0.3)),
                            Center(
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
                                    onPressed: () => provider.fetchVendorCategory(widget.categoryId, widget.subCategoryId),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7B2CBF),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Retry"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      if (provider.vendorCategory.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(height: AppSize.height(0.4)),
                            const Center(child: Text("No Vendor List found")),
                          ],
                        );
                      }

                      final filteredVendors = provider.vendorCategory.where((vendor) {
                        return vendor.businessName.toLowerCase().contains(_searchQuery);
                      }).toList();

                      if (filteredVendors.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(height: AppSize.height(0.4)),
                            const Center(
                              child: Text(
                                "no search item found",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 24 : AppSize.width(0.04),
                          vertical: isTablet ? 20 : AppSize.width(0.04),
                        ),
                        itemCount: filteredVendors.length,
                        itemBuilder: (context, index) {
                          final vendor = filteredVendors[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: isTablet ? 24 : 16),
                            child: VendorCard(
                              logo: vendor.kycDetail?.shopPhoto?.url ?? "",
                              title: vendor.businessName,
                              vendorId: vendor.user?.vendorId ?? "",
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
                                      bannerLogo: vendor.kycDetail?.shopPhoto?.url ?? "",
                                      vendorName: vendor.businessName,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
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
                        MaterialPageRoute(
                          builder: (context) => const CheckOutScreen(),
                        ),
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
