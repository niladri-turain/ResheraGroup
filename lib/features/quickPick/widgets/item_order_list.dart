import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:resheragroup/features/quickPick/model/order_list_model.dart';
import 'package:resheragroup/features/quickPick/provider/order_list_provider.dart';
import 'package:resheragroup/features/quickPick/screen/itemOrder/order_details_screen.dart';

class ItemOrderList extends StatelessWidget {
  final String searchQuery;
  const ItemOrderList({super.key, this.searchQuery = ''});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildSkeletonList();
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        final allOrders = provider.orderListData?.data ?? [];
        final orders = allOrders.where((order) {
          final query = searchQuery.toLowerCase();
          final orderNo = (order.orderNo ?? '').toLowerCase();
          final orderId = (order.id ?? '').toLowerCase();
          return orderNo.contains(query) || orderId.contains(query);
        }).toList();

        if (orders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderItemCard(order: order);
          },
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(height: 120, width: double.infinity),
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final OrderData order;

  const OrderItemCard({super.key, required this.order});

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Cancelled':
        return Colors.red.shade600;
      case 'Pending':
        return Colors.orange.shade600;
      case 'Delivered':
        return Colors.green.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items?.isNotEmpty == true ? order.items![0] : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(orderId: order.id ?? ''),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        order.orderNo ?? order.id ?? '',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                    Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.orderStatusLabel),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      order.orderStatusLabel ?? 'Unknown',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Image.network(
                  //     firstItem?.image ?? 'https://via.placeholder.com/80',
                  //     height: 80,
                  //     width: 80,
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) => Container(
                  //       height: 80,
                  //       width: 80,
                  //       color: Colors.grey[200],
                  //       child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   firstItem?.productName ?? 'Order #${order.orderNo}',
                        //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        // const SizedBox(height: 5),
                        Text(
                          "Date: ${_formatDate(order.createdAt)}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text("Qty: ", style: TextStyle(color: Colors.grey)),
                            Text("${order.totalItems ?? 0}",
                                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Item Price ",
                                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                                    ),
                                    Text(
                                      "₹${firstItem?.finalPrice ?? 0}",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total Price ",
                                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
                                    ),
                                    Text(
                                      "₹${order.grandTotal ?? 0}",
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
