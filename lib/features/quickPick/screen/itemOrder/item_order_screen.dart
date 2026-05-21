import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/provider/order_list_provider.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/service/location_service.dart';
import '../../../../widgets/custom_search_widget.dart';
import '../../widgets/item_order_list.dart';

class ItemOrderScreen extends StatefulWidget {
  const ItemOrderScreen({super.key});

  @override
  State<ItemOrderScreen> createState() => _ItemOrderScreenState();
}

class _ItemOrderScreenState extends State<ItemOrderScreen> {
  String? cachedAddress;
  String _searchQuery = '';
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
        title: Column(
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
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderListProvider>().fetchOrders();
    });
  }
}