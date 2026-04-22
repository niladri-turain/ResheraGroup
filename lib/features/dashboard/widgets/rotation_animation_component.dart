
import 'package:flutter/material.dart';


import '../../../core/constants/app_sizes.dart'; // 👈 add this

class CustomAnimatedDashboardCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color themeColor;
  final VoidCallback? onTap;

  const CustomAnimatedDashboardCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.themeColor,
    this.onTap
  });

  @override
  State<CustomAnimatedDashboardCard> createState() => _CustomAnimatedDashboardCardState();
}

class _CustomAnimatedDashboardCardState extends State<CustomAnimatedDashboardCard>
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

    // ⚠️ ensure init called (safe if already called)
    AppSize.init(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Background Glow & Rotating Border
          Container(
            width: AppSize.width(0.40),   // 👈 responsive
            height: AppSize.height(0.22), // 👈 responsive
            decoration: BoxDecoration(
              color: const Color(0xFF1A1212),
              borderRadius: BorderRadius.circular(AppSize.width(0.03)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.width(0.03)),
              child: Stack(
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: Center(
                      child: CustomPaint(
                        size: Size(
                          AppSize.width(0.60),
                          AppSize.width(0.60),
                        ), // 👈 responsive painter size
                        painter: ContinuousBlurPainter(color: widget.themeColor),
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.themeColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                      gradient: RadialGradient(
                        colors: [
                          widget.themeColor.withOpacity(0.2),
                          widget.themeColor.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Content
          SizedBox(
            width: AppSize.width(0.39),
            height: AppSize.height(0.21),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.height(0.015),
                horizontal: AppSize.width(0.025),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: AppSize.height(0.01)),

                  Flexible(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.width(0.04),
                          vertical: AppSize.height(0.008),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(AppSize.width(0.03)),
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppSize.width(0.03), // 👈 responsive text
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
          ),
        ],
      ),
    );
  }
}

// Painter unchanged
class ContinuousBlurPainter extends CustomPainter {
  final Color color;
  ContinuousBlurPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final sweepGradientShader = SweepGradient(
      center: Alignment.center,
      colors: [
        color,
        color.withOpacity(0.8),
        Colors.transparent,
      ],
      stops: const [
        0.0,
        0.3,
        0.6,
      ],
    ).createShader(rect);

    final Paint borderPaint = Paint()
      ..shader = sweepGradientShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);

    canvas.drawRRect(rRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ContinuousBlurPainter oldDelegate) => false;
}