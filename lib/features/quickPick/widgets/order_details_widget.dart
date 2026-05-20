import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class OrderDetailsWidget extends StatelessWidget {
  final String orderId;
  final String orderDate;
  final String orderStatus; // 'Pending', 'Processing', 'Delivered'
  final String statusDescription;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final int totalQuantity;
  final double itemMrp;
  final double discount;
  final double itemPrice;
  final double loyaltyBonus;
  final double platformCharge;
  final double deliveryCharge;
  final double grandTotal;
  final VoidCallback? onCancelOrder;

  const OrderDetailsWidget({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.orderStatus,
    required this.statusDescription,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalQuantity,
    required this.itemMrp,
    required this.discount,
    required this.itemPrice,
    required this.loyaltyBonus,
    required this.platformCharge,
    required this.deliveryCharge,
    required this.grandTotal,
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
              Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Date: $orderDate", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStepIndicator("Pending", true),
              _buildLine(orderStatus == 'Processing' || orderStatus == 'Delivered'),
              _buildStepIndicator("Processing", orderStatus == 'Processing' || orderStatus == 'Delivered'),
              _buildLine(orderStatus == 'Delivered'),
              _buildStepIndicator("Delivered", orderStatus == 'Delivered'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            statusDescription,
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
              Expanded(child: Text("$customerName | $customerPhone", style: const TextStyle(fontSize: 13))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.home_outlined, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(deliveryAddress, style: const TextStyle(fontSize: 13, color: Colors.black87))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("Qty: ${item.quantity}", style: const TextStyle(color: Colors.orange, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text("₹${item.mrp}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text("₹${item.price}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
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
          _summaryRow("Total Quantity", "$totalQuantity"),
          _summaryRow("Item MRP", "₹$itemMrp"),
          _summaryRow("Discount", "-₹$discount", valueColor: Colors.green),
          _summaryRow("Item Price", "₹$itemPrice"),
          _summaryRow("Loyalty Bonus", "$loyaltyBonus"),
          _summaryRow("Platform charge", "₹$platformCharge", valueColor: Colors.green),
          _summaryRow("Delivery charge", "₹$deliveryCharge", valueColor: Colors.green),
          const Divider(height: 24, thickness: 1, color: Color(0xFFEEEEEE)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Grand total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("₹$grandTotal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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

class OrderItem {
  final String name;
  final int quantity;
  final double mrp;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.mrp,
    required this.price,
  });
}
