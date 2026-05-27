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
        title: Consumer2<LoginProvider, UserAddressProvider>(
          builder: (context, loginProvider, addressProvider, child) {
            String displayLocation = addressProvider.selectedAddress?.address ?? addressProvider.guestLocation ?? "Fetching location...";

            return Column(
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

          return SingleChildScrollView(
            child: Column(
              children: [
                OrderDetailsWidget(
                  order: order,
                  onCancelOrder: () {
                    // Handle logic
                  },
                ),
                const SizedBox(height: 15,),
                Consumer<DownloadInvoiceProvider>(
                  builder: (context, downloadProvider, child) {
                    return GestureDetector(
                      onTap: downloadProvider.isDownloading 
                        ? null 
                        : () {
                          downloadProvider.downloadInvoice(
                            context, 
                            "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf", 
                            "Invoice_${widget.orderId}.pdf"
                          );
                        },
                      child: Container(
                        width: AppSize.screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                downloadProvider.isDownloading 
                                  ? "Downloading... ${(downloadProvider.downloadProgress * 100).toStringAsFixed(0)}%" 
                                  : "Download Invoice",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 8),
                              downloadProvider.isDownloading
                                ? const SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                                  )
                                : const Icon(Icons.download_outlined, color: Colors.orange),
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
