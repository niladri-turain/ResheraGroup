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
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    return Consumer<OrderListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.orders.isEmpty) {
          return _buildSkeletonList(isTablet);
        }

        final allOrders = provider.orders;
        final orders = allOrders.where((order) {
          final query = searchQuery.toLowerCase();
          final orderNo = (order.orderNo ?? '').toLowerCase();
          final orderId = (order.id ?? '').toLowerCase();
          return orderNo.contains(query) || orderId.contains(query);
        }).toList();

        return RefreshIndicator(
          onRefresh: () => provider.fetchOrders(isRefresh: true),
          color: const Color(0xFF7B2CBF),
          child: _buildContent(provider, orders, isTablet),
        );
      },
    );
  }

  Widget _buildContent(OrderListProvider provider, List<OrderData> orders, bool isTablet) {
    if (provider.errorMessage != null && provider.orders.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: isTablet ? 18 : 14),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (orders.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                "No orders found",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(isTablet ? 20 : 10),
      itemCount: orders.length + 1,
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return OrderItemCard(order: order);
        } else {
          // Load More Section
          if (provider.isMoreLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(color: const Color(0xFF7B2CBF), strokeWidth: isTablet ? 4 : 2)),
            );
          } else if (provider.hasMore) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => provider.fetchOrders(isRefresh: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B2CBF),
                    foregroundColor: Colors.white,
                    padding: isTablet ? const EdgeInsets.symmetric(horizontal: 40, vertical: 16) : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text("Load More", style: TextStyle(fontSize: isTablet ? 18 : 14)),
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "No more orders",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: isTablet ? 16 : 12),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildSkeletonList(bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 20 : 10),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(height: isTablet ? 180 : 120, width: double.infinity),
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
        return Colors.green.shade600;
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
    final bool isTablet = MediaQuery.of(context).size.width > 600;
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
        margin: EdgeInsets.only(bottom: isTablet ? 20 : 12),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 10, vertical: isTablet ? 12 : 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8, vertical: isTablet ? 6 : 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        order.orderNo ?? order.id ?? '',
                        style: TextStyle(fontSize: isTablet ? 18 : 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12, vertical: isTablet ? 6 : 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.orderStatusLabel),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      order.orderStatusLabel ?? 'Unknown',
                      style: TextStyle(color: Colors.white, fontSize: isTablet ? 18 : 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 10, vertical: isTablet ? 12 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${_formatDate(order.createdAt)}",
                          style: TextStyle(color: Colors.grey, fontSize: isTablet ? 18 : 12),
                        ),
                        SizedBox(height: isTablet ? 10 : 5),
                        Row(
                          children: [
                            Text("Qty: ", style: TextStyle(color: Colors.grey, fontSize: isTablet ? 18 : 14)),
                            Text("${order.totalItems ?? 0}",
                                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: isTablet ? 18 : 14)),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Item Price ",
                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: isTablet ? 18 : 12),
                                    ),
                                    Text(
                                      "₹${firstItem?.finalPrice ?? 0}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: isTablet ? 20 : 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isTablet ? 8 : 4),
                                Row(
                                  children: [
                                    Text(
                                      "Total Price ",
                                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: isTablet ? 18 : 12),
                                    ),
                                    Text(
                                      "₹${order.grandTotal ?? 0}",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: isTablet ? 20 : 16),
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
