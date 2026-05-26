import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/provider/order_list_provider.dart';
import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/service/shared_pref_service.dart';
import '../../../../widgets/custom_search_widget.dart';
import '../../../login/screen/login_screen.dart';
import '../../provider/view_cart_list_provider.dart';
import '../../widgets/item_order_list.dart';
import '../checkout/check_out_screen.dart';

class ItemOrderScreen extends StatefulWidget {
  const ItemOrderScreen({super.key});

  @override
  State<ItemOrderScreen> createState() => _ItemOrderScreenState();
}

class _ItemOrderScreenState extends State<ItemOrderScreen> {
  String currentLocation = "Fetching location...";
  String _searchQuery = '';

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
    return Scaffold(
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
                  "Order Summary",
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
          Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Column(
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
                    hintText: 'Search order ID or item...',
                  ),
                ),
                Expanded(child: ItemOrderList(),)

              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderListProvider>().fetchOrders();
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

    _fetchLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ViewCartListProvider>().fetchCart();
    });
  }
}