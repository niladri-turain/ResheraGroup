import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/service/location_service.dart';
import '../../provider/order_details_provider.dart';
import '../../widgets/order_details_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? cachedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderDetailsProvider>().fetchOrderDetails(widget.orderId);
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
      body: Consumer<OrderDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final order = provider.orderDetailsData?.data;

          if (order == null) {
            return const Center(child: Text("Order not found"));
          }

          return OrderDetailsWidget(
            order: order,
            onCancelOrder: () {
              // Handle logic
            },
          );
        },
      ),
    );
  }
}
