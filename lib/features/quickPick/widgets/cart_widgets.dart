import 'package:flutter/material.dart';

class CartCounterWidget extends StatefulWidget {
  final int initialCount;
  final Function(int) onCountChanged;
  final String initialLabel;
  final Color activeColor;

  const CartCounterWidget({
    super.key,
    this.initialCount = 0,
    required this.onCountChanged,
    this.initialLabel = 'ADD',
    this.activeColor = const Color(0xFF7B2CBF),
  });

  @override
  State<CartCounterWidget> createState() => _CartCounterWidgetState();
}

class _CartCounterWidgetState extends State<CartCounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  void _increment() {
    setState(() {
      _count++;
      widget.onCountChanged(_count);
    });
  }

  void _decrement() {
    if (_count > 0) {
      setState(() {
        _count--;
        widget.onCountChanged(_count);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_count == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _increment,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.activeColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text(
            widget.initialLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: widget.activeColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 24),
            onPressed: _decrement,
          ),
          Text(
            '$_count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: _increment,
          ),
        ],
      ),
    );
  }
}

class FloatingCartBar extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;
  final double bottomOffset;

  const FloatingCartBar({
    super.key,
    required this.itemCount,
    required this.onTap,
    this.bottomOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomOffset),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 150,
          margin: EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF7B2CBF), // Green color from image
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular images stack
              // SizedBox(
              //   width: 75,
              //   height: 40,
              //   child: Stack(
              //     children: [
              //       _buildCircleImage(0, 'https://picsum.photos/100/100?1'),
              //       _buildCircleImage(18, 'https://picsum.photos/100/100?2'),
              //       _buildCircleImage(36, 'https://picsum.photos/100/100?3'),
              //     ],
              //   ),
              // ),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'View cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$itemCount Items',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleImage(double left, String imageUrl) {
    return Positioned(
      left: left,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
