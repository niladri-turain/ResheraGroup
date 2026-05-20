import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/service/location_service.dart';
import '../../widgets/order_details_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? cachedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddress();
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
      backgroundColor: const Color(0xFFF5F5F5),
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
              "Order Details",
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
      ),
      body: OrderDetailsWidget(
        orderId: "ORD180526173633781",
        orderDate: "18 May, 2026",
        orderStatus: "Pending",
        statusDescription: "Your order has been placed and is pending.",
        customerName: "Dev Testing",
        customerPhone: "8420909090",
        deliveryAddress: "Howrah Maidan, Howrah, Kolkata Metropolitan Area, Howrah, West Bengal, 711317, India",
        items: [
          OrderItem(
            name: "CODE 0104",
            quantity: 1,
            mrp: 1000.00,
            price: 100.00,
          ),
        ],
        totalQuantity: 2,
        itemMrp: 1000.00,
        discount: 900.00,
        itemPrice: 100.00,
        loyaltyBonus: 0.00,
        platformCharge: 5.00,
        deliveryCharge: 100.00,
        grandTotal: 205.00,
        onCancelOrder: () {
          // Handle logic
        },
      ),
    );
  }
}
