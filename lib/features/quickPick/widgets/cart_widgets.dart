import 'package:flutter/material.dart';

class CartCounterWidget extends StatefulWidget {
  final int initialCount;
  final Function(int) onCountChanged;
  final String initialLabel;
  final Color activeColor;
  final bool isLoading;

  const CartCounterWidget({
    super.key,
    this.initialCount = 0,
    required this.onCountChanged,
    this.initialLabel = 'ADD',
    this.activeColor = const Color(0xFF7B2CBF),
    this.isLoading = false,
  });

  @override
  State<CartCounterWidget> createState() => _CartCounterWidgetState();
}

class _CartCounterWidgetState extends State<CartCounterWidget> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  @override
  void didUpdateWidget(covariant CartCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync with initialCount if it has actually changed from the parent side.
    // This prevents the "jump back" effect (e.g. 2 -> 1 -> 2) during asynchronous API calls.
    if (widget.initialCount != oldWidget.initialCount) {
      setState(() {
        _count = widget.initialCount;
      });
    }
  }

  void _increment() {
    if (widget.isLoading) return;
    if (_count == 0) {
      // Don't update local state yet for the first add to handle vendor conflicts properly
      widget.onCountChanged(1);
    } else {
      setState(() {
        _count++;
        widget.onCountChanged(_count);
      });
    }
  }

  void _decrement() {
    if (widget.isLoading) return;
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
          onPressed: widget.isLoading ? null : _increment,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.activeColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(
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
            icon: widget.isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.remove, color: Colors.white, size: 24),
            onPressed: widget.isLoading ? null : _decrement,
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
            icon: widget.isLoading 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.add, color: Colors.white, size: 24),
            onPressed: widget.isLoading ? null : _increment,
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
  final String label;

  const FloatingCartBar({
    super.key,
    required this.itemCount,
    required this.onTap,
    this.bottomOffset = 0,
    this.label = 'View cart',
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
          margin: const EdgeInsets.only(bottom: 20),
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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
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
