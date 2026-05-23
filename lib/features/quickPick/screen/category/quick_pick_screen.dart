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
import '../checkout/check_out_screen.dart';


import 'package:resheragroup/features/login/provider/user_address_provider.dart';
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
          final addresses = context.read<UserAddressProvider>().addressModel?.data?.shipping;
          if (addresses != null && addresses.isNotEmpty) {
            setState(() {
              _selectedShippingAddress = addresses.first;
              currentLocation = _formatAddress(_selectedShippingAddress!);
            });
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

  String _formatAddress(ShippingAddress addr) {
    return addr.address ?? "";
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
    final addressProvider = context.read<UserAddressProvider>();
    final addresses = addressProvider.addressModel?.data?.shipping ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Shipping Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("No shipping addresses found")),
                )
              else
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      final isSelected = _selectedShippingAddress?.id == addr.id;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedShippingAddress = addr;
                            currentLocation = _formatAddress(addr);
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: const Color(0xFF7B2CBF).withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4C4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  addr.type?.toLowerCase() == 'home' ? Icons.home_outlined : Icons.business_outlined,
                                  color: const Color(0xFFD2691E),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatAddress(addr),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Phone | ${addr.phone ?? ''}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
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
                ),
            ],
          ),
        );
      },
    );
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
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                      return CustomHeaderWidget(
                        userName: loginProvider.userName ?? AppStrings.guestUser,
                        location: currentLocation,
                        onNotificationTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckOutScreen()),
                          );
                        },
                        // onLocationTap: _showAddressBottomSheet,
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