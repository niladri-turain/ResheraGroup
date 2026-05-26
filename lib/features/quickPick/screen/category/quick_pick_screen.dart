import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:resheragroup/core/constants/app_sizes.dart';
import 'package:resheragroup/features/dashboard/screen/dashboard_screen.dart';
import 'package:resheragroup/features/quickPick/provider/category_provider.dart';
import 'package:resheragroup/features/quickPick/screen/subCategory/sub_category_screeen.dart';
import 'package:resheragroup/features/quickPick/widgets/category_card_widget.dart';
import 'package:resheragroup/features/quickPick/widgets/custom_header_widget.dart';
import 'package:resheragroup/features/quickPick/provider/view_cart_list_provider.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import 'package:resheragroup/features/quickPick/widgets/cart_widgets.dart';
import 'package:resheragroup/main_screen.dart';
import '../../../login/provider/user_address_provider.dart';
import '../checkout/check_out_screen.dart';


import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/model/user_address_model.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/shared_pref_service.dart';
import 'package:resheragroup/core/service/location_service.dart';
import '../../widgets/custom_quickpick_buttom_navigation.dart';

class QuickPickScreen extends StatefulWidget {
  const QuickPickScreen({super.key});

  @override
  State<QuickPickScreen> createState() => _QuickPickScreenState();
}

class _QuickPickScreenState extends State<QuickPickScreen> {
  int selectedIndex = 1; // Category selected by default
  String currentLocation = "Fetching location...";
  ShippingAddress? _selectedShippingAddress;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final prefService = sl<SharedPrefService>();
    final token = await prefService.getToken();

    if (token != null && token.isNotEmpty) {
      if (mounted) {
        context.read<UserAddressProvider>().fetchUserAddresses(token).then((_) {
          final addressProvider = context.read<UserAddressProvider>();
          final addresses = addressProvider.addressModel?.data?.shipping;
          if (addresses != null && addresses.isNotEmpty) {
            // Auto-select first address if none selected
            if (addressProvider.selectedAddress == null) {
              addressProvider.setSelectedAddress(addresses.first);
            }
          } else {
            _fetchLocation();
          }
        });
      }
    } else {
      _fetchLocation();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
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

  Future<void> _fetchLocation() async {
    String address = await LocationService.getCurrentAddress();
    if (mounted) {
      setState(() {
        currentLocation = address;
      });
    }
  }



  void _onNavTap(int index) {
    if (index == 3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
            (route) => false,
      );
      return;
    }


    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        debugPrint("Navigate to Home Screen");
        break;
      case 1:
        debugPrint("Navigate to Category Screen");
        break;
      case 2:
        debugPrint("Navigate to Shopping Screen");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        /// 🔻 Bottom Navigation Bar
        bottomNavigationBar: CustomTopNavigationBar(
          selectedIndex: selectedIndex,
          onItemSelected: _onNavTap,
        ),

        /// 🔹 Main Content
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer2<LoginProvider, UserAddressProvider>(
                    builder: (context, loginProvider, addressProvider, child) {
                      String displayLocation = currentLocation;
                      if (addressProvider.selectedAddress != null) {
                        displayLocation = addressProvider.selectedAddress!.address ?? "";
                      }

                      return CustomHeaderWidget(
                        userName: loginProvider.userName ?? AppStrings.guestUser,
                        location: displayLocation,
                        onNotificationTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                          );
                        },
                        onLocationTap: loginProvider.userName != null ? _showAddressBottomSheet : null,
                        onProfileTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(initialIndex: 3),
                            ),
                            (route) => false,
                          );
                        },
                        onSearch: (value) {},
                      );
                    },
                  ),
    
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.width(0.04),
                      vertical: AppSize.height(0.02),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.searchBycate,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppSize.width(0.045),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSize.height(0.015)),
                        Consumer<CategoryProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 8,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppSize.width(0.03),
                                  mainAxisSpacing: AppSize.height(0.015),
                                  childAspectRatio: 1.25,
                                ),
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(AppSize.width(0.04)),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
    
                            if (provider.errorMessage != null) {
                              return SizedBox(
                                height: AppSize.height(0.4),
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () => provider.fetchCategories(),
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
    
                            if (provider.categories.isEmpty) {
                              return const Center(child: Text("No categories found"));
                            }
    
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.categories.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: AppSize.width(0.03),
                                mainAxisSpacing: AppSize.height(0.015),
                                childAspectRatio: 1.25,
                              ),
                              itemBuilder: (context, index) {
                                final category = provider.categories[index];
                                return CategoryCard(
                                  title: category.name,
                                  imagePath: category.image,
                                  isNetworkImage: true,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SubCategoryScreen(
                                          categoryTitle: category.name,
                                          categoryId: category.id,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
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
      ),
    );
  }
}