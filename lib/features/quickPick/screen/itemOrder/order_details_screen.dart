import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/widgets/address_selection_sheet.dart';
import 'package:resheragroup/features/login/provider/login_provider.dart';
import 'package:resheragroup/features/login/provider/user_address_provider.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/service/location_service.dart';
import '../../../../core/service/shared_pref_service.dart';
import '../../provider/order_details_provider.dart';
import '../../provider/download_invoice_provider.dart';
import '../../widgets/order_details_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderDetailsProvider>().fetchOrderDetails(widget.orderId);
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

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        toolbarHeight: isTablet ? 80 : 56,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: isTablet ? 30 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer2<LoginProvider, UserAddressProvider>(
          builder: (context, loginProvider, addressProvider, child) {
            String displayLocation = addressProvider.selectedAddress?.address ?? addressProvider.guestLocation ?? "Fetching location...";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 24 : 18,
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
                        fontSize: isTablet ? 20 : AppSize.width(0.032),
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
      ),
      body: Consumer<OrderDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!, style: TextStyle(fontSize: isTablet ? 18 : 14)));
          }

          final order = provider.orderDetailsData?.data;

          if (order == null) {
            return Center(child: Text("Order not found", style: TextStyle(fontSize: isTablet ? 18 : 14)));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                OrderDetailsWidget(
                  orderId: widget.orderId,
                  order: order,
                  onCancelOrder: () {
                    // Handle logic
                  },
                ),
                const SizedBox(height: 15,),
                if (order.orderStatusLabel?.toLowerCase() == 'confirmed' || order.orderStatusLabel?.toLowerCase() == 'confirmed')
                  Consumer<DownloadInvoiceProvider>(
                    builder: (context, downloadProvider, child) {
                      return GestureDetector(
                      onTap: downloadProvider.isDownloading 
                        ? null 
                        : () {
                          downloadProvider.downloadInvoice(
                            context, 
                            widget.orderId
                          );
                        },
                      child: Container(
                        width: isTablet ? 300 : AppSize.screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 16.0 : 8.0, vertical: isTablet ? 12 : 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                downloadProvider.isDownloading 
                                  ? "Downloading... ${(downloadProvider.downloadProgress * 100).toStringAsFixed(0)}%" 
                                  : "Download Invoice",
                                style: TextStyle(fontSize: isTablet ? 18 : 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              downloadProvider.isDownloading
                                ? SizedBox(
                                    width: isTablet ? 20 : 15,
                                    height: isTablet ? 20 : 15,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                                  )
                                : Icon(Icons.download_outlined, color: Colors.orange, size: isTablet ? 28 : 24),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50,)
              ],
            ),
          );
        },
      ),
    );
  }

}
