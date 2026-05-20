import 'package:flutter/material.dart';
import 'package:resheragroup/features/quickPick/screen/itemOrder/order_details_screen.dart';

class ItemOrderList extends StatelessWidget {
  const ItemOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    // স্ট্যাটিক ডাটা লিস্ট
    final List<Map<String, dynamic>> orders = [
      {
        "orderId": "ORD110526112925997",
        "title": "tttttttttttt",
        "qty": 2,
        "loyalty": "10.00",
        "price": "2,085.00",
        "date": "11 May, 2026",
        "status": "Cancelled"
      },
      {
        "orderId": "ORD110526105051711",
        "title": "tttttttttttt",
        "qty": 1,
        "loyalty": "5.00",
        "price": "1,045.00",
        "date": "11 May, 2026",
        "status": "Pending"
      },
      {
        "orderId": "ORD090526183735874",
        "title": "tttttttttttt",
        "qty": 1,
        "loyalty": "5.00",
        "price": "1,045.00",
        "date": "09 May, 2026",
        "status": "Delivered"
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderItemCard(order: order);
      },
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderItemCard({super.key, required this.order});

  // স্ট্যাটাস অনুযায়ী কালার রিটার্ন করার ফাংশন
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Cancelled':
        return Colors.red.shade600;
      case 'Pending':
        return Colors.orange.shade600;
      case 'Delivered':
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderDetailsScreen(),
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
                        order['orderId'],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['status']),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      order['status'],
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // মাঝের অংশ: ইমেজ এবং ডিটেইলস
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // প্রোডাক্ট ইমেজ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://via.placeholder.com/80', // আপনার ইমেজ ইউআরএল এখানে দিন
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

                  // টেক্সট ডিটেইলস
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['title'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Text("Qty: ", style: TextStyle(color: Colors.grey)),
                            Text("${order['qty']}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.cyan.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "${order['loyalty']} Loyalty",
                                  style: TextStyle(color: Colors.cyan.shade700, fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹${order['price']}",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Date: ${order['date']}",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
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