import 'package:flutter/material.dart';
import '../model/order_list_model.dart';

class OrderDetailsWidget extends StatelessWidget {
  final OrderData order;
  final VoidCallback? onCancelOrder;

  const OrderDetailsWidget({
    super.key,
    required this.order,
    this.onCancelOrder,
  });

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
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = order.orderStatusLabel ?? 'Pending';
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
              Text(order.orderNo ?? order.id ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Date: ${order.placedAt ?? ''}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStepIndicator("Pending", true),
              _buildLine(status == 'Processing' || status == 'Delivered'),
              _buildStepIndicator("Processing", status == 'Processing' || status == 'Delivered'),
              _buildLine(status == 'Delivered'),
              _buildStepIndicator("Delivered", status == 'Delivered'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            order.notes ?? "Your order has been placed and is ${status.toLowerCase()}.",
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
              Expanded(child: Text("Customer | ID: ${order.userId ?? ''}", style: const TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.home_outlined, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text("Address not available in response", style: const TextStyle(fontSize: 13, color: Colors.black87))),
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
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (item.attributes != null && item.attributes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.attributes!.map((a) => "${a.name}: ${a.value}").join(", "),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("Qty: ${item.quantity}", style: const TextStyle(color: Colors.orange, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text("₹${item.mrp}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text("₹${item.finalPrice}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
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
          _summaryRow("Delivery charge", "₹${order.deliveryCharge ?? 0}", valueColor: Colors.green),
          const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Grand total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("₹${order.grandTotal ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: onCancelOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE54D4D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Waiting for invoice",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
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
