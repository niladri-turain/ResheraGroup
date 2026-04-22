import 'dart:math';
import 'package:flutter/material.dart';

class CustomRotationAnimation extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color themeColor;

  const CustomRotationAnimation({
    super.key,
    required this.title,
    required this.imagePath,
    required this.themeColor,
  });

  @override
  State<CustomRotationAnimation> createState() => _CustomRotationAnimationState();
}

class _CustomRotationAnimationState extends State<CustomRotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Rotating Glow Border
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(160, 185),
              painter: GlowingBorderPainter(
                animationValue: _controller.value,
                baseColor: widget.themeColor,
              ),
            );
          },
        ),

        // 2. Main Card Body
        Container(
          width: 154,
          height: 178,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        widget.themeColor.withOpacity(0.08),
                        widget.themeColor.withOpacity(0.18),
                      ],
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // --- IMAGE SECTION ---

                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // --- TITLE SECTION ---

                    Flexible(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.themeColor.withOpacity(0.5),
                              width: 0.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.orange,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            widget.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter (Kono change dorkar nei, height/width upore handle kora hoyeche)
class GlowingBorderPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;

  GlowingBorderPainter({required this.animationValue, required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final Paint paint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          baseColor,
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(animationValue * 2 * pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant GlowingBorderPainter oldDelegate) => true;
}