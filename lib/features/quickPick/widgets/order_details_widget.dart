import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../login/provider/login_provider.dart';
import '../model/order_list_model.dart';
import '../provider/cancel_reason_provider.dart';
import '../model/cancel_reason_model.dart';
import '../provider/cancel_order_provider.dart';
import '../provider/order_list_provider.dart';

class OrderDetailsWidget extends StatelessWidget {
  final OrderData order;
  final VoidCallback? onCancelOrder;

  const OrderDetailsWidget({
    super.key,
    required this.order,
    this.onCancelOrder,
  });

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('d\'${_getDayOfMonthSuffix(dt.day)}\' MMMM, yyyy').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  String _getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }
    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }
    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _showCancelBottomSheet(BuildContext context, String orderItemId) {
    CancelReason? selectedReason;
    final TextEditingController descriptionController = TextEditingController();
    
    // Fetch reasons when bottom sheet opens
    final cancelReasonProvider = Provider.of<CancelReasonProvider>(context, listen: false);
    cancelReasonProvider.fetchCancelReasons();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Consumer2<CancelReasonProvider, CancelOrderProvider>(
            builder: (context, reasonProvider, cancelProvider, child) {
              return Column(
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
                    "Cancel Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select a reason for cancellation",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Reason for cancellation",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  reasonProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CancelReason>(
                              isExpanded: true,
                              hint: const Text("Select Reason"),
                              value: selectedReason,
                              items: reasonProvider.reasons.map((CancelReason reason) {
                                return DropdownMenuItem<CancelReason>(
                                  value: reason,
                                  child: Text(reason.reason ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setModalState(() {
                                  selectedReason = value;
                                });
                              },
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description (Optional)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Tell us more about your cancellation...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedReason == null || reasonProvider.isLoading || cancelProvider.isLoading
                          ? null
                          : () async {
                              try {
                                final result = await cancelProvider.cancelOrderItem(
                                  orderItemId: orderItemId,
                                  cancelReasonId: selectedReason!.id!.toString(),
                                  cancelNote: descriptionController.text,
                                );
                                
                                if (result?.success == true) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result?.message ?? "Order item cancelled successfully")),
                                    );
                                    // Refresh order list
                                    Provider.of<OrderListProvider>(context, listen: false).fetchOrders();
                                    // Pop bottom sheet
                                    Navigator.pop(context);
                                    // Pop order details screen to go back to order list
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result?.message ?? "Failed to cancel order item")),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CBF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: cancelProvider.isLoading
                          ? const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                          : const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildStatusCard(),
          const SizedBox(height: 12),
          _buildDeliveryDetails(),
          const SizedBox(height: 12),
          _buildProductDetails(),
          const SizedBox(height: 12),
          _buildOrderSummary(),
          if (order.orderStatusLabel?.toLowerCase() == 'pending' && order.items != null && order.items!.isNotEmpty) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showCancelBottomSheet(context, order.items!.first.id ?? ''),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Cancel Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusLabel = order.orderStatusLabel ?? 'Pending';
    final statusLower = statusLabel.toLowerCase();
    final isCancelled = statusLower == 'cancelled';

    bool isReached(String target) {
      // Remove 'processing' as requested. Map 'confirmed' or 'processing' to 'delivered' status for UI.
      String effectiveStatus = statusLower;
      if (statusLower == 'confirmed' || statusLower == 'processing') {
        effectiveStatus = 'delivered';
      }

      final stages = ['pending', 'confirmed', 'delivered'];
      int currentIdx = stages.indexOf(effectiveStatus);
      int targetIdx = stages.indexOf(target.toLowerCase());
      if (currentIdx == -1) return target.toLowerCase() == 'pending';
      return currentIdx >= targetIdx;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.orderNo ?? order.id ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Date: ${_formatDate(order.placedAt ?? order.createdAt)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          if (isCancelled)
            Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  "Order $statusLabel",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                _buildStepIndicator("Pending", true),
                _buildLine(isReached('confirmed')),
                _buildStepIndicator("Confirmed", isReached('confirmed')),
                _buildLine(isReached('delivered')),
                _buildStepIndicator("Delivered", isReached('delivered')),
              ],
            ),
          const SizedBox(height: 20),
          Text(
            order.notes ?? "Your order has been placed and is ${statusLabel.toLowerCase()}.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.check_circle_outline,
            color: isActive ? Colors.green : Colors.grey.shade300,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 40,
      height: 1,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }

  Widget _buildDeliveryDetails() {
    String shippingAddr = "Address not available";
    if (order.addresses != null && order.addresses!.isNotEmpty) {
      final firstAddr = order.addresses!.first;
      if (firstAddr is Map) {
        shippingAddr =
            firstAddr['shipping_address'] ?? firstAddr['billing_address'] ?? "Address not available";
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Delivery Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Consumer<LoginProvider>(
                  builder: (context, loginProvider, child) {
                    return Text(
                      "Customer | ${loginProvider.userName ?? 'ID: ${order.userId ?? ''}'}",
                      style: const TextStyle(fontSize: 13),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.home_outlined, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(shippingAddr,
                      style: const TextStyle(fontSize: 13, color: Colors.black87))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    final items = order.items ?? [];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Product Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.image ?? 'https://via.placeholder.com/80',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.productName ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (item.attributes != null && item.attributes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.attributes!.map((attr) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 6, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "${attr.name}: ",
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${attr.value}",
                              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                const SizedBox(height: 8),

                // Status and Cancel Note removed as per requirement: "item er moddhe list e kno cancel likhbe na"
                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Qty: ${item.quantity}",
                        style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${item.mrp}",
                      style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "₹${item.finalPrice?.toStringAsFixed(2) ?? '0.00'}",
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Spacer(),
                    const Text(
                      "Total price : ",
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "₹${item.subtotal?.toStringAsFixed(2) ?? '0.00'}",
                      style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (items.indexOf(item) != items.length - 1)
                  const Divider(height: 24, thickness: 0.5, color: Color(0xFFEEEEEE)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _summaryRow("Invoice No", order.invoiceNo ?? 'N/A'),
          _summaryRow("Payment Method", order.paymentMethodLabel ?? 'N/A'),
          _summaryRow("Total Quantity", "${order.totalItems ?? 0}"),
          _summaryRow("Item Total", "₹${order.itemsTotal ?? 0}"),
          _summaryRow("Discount", "-₹${order.discountAmount ?? 0}", valueColor: Colors.green),
          _summaryRow("Platform charge", "₹${order.platformCharge ?? 0}", valueColor: Colors.green),

          const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Grand total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("₹${order.grandTotal ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 24),
          // Center(
          //   child: SizedBox(
          //     width: 150,
          //     child: ElevatedButton(
          //       onPressed: onCancelOrder,
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor:  const Color(0xFF7B2CBF),
          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          //         padding: const EdgeInsets.symmetric(vertical: 12),
          //       ),
          //       child: const Text(
          //         "Download invoice",
          //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(color: valueColor ?? Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
