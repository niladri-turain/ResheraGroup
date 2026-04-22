import 'package:flutter/material.dart';

class AnimatedIconImage extends StatefulWidget {
  final String imagePath;

  const AnimatedIconImage({super.key, required this.imagePath});

  @override
  State<AnimatedIconImage> createState() => _AnimatedIconImageState();
}

class _AnimatedIconImageState extends State<AnimatedIconImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Image.asset(widget.imagePath),
    );
  }
}