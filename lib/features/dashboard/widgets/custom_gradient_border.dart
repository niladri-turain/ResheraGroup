import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:resheragroup/core/constants/app_sizes.dart';


class GradientBorderText extends StatefulWidget {
  final String text;

  const GradientBorderText({super.key, required this.text});

  @override
  State<GradientBorderText> createState() => _GradientBorderTextState();
}

class _GradientBorderTextState extends State<GradientBorderText>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: AppSize.height(0.012),   // 👈 responsive
          horizontal: AppSize.width(0.03),   // 👈 responsive
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppSize.width(0.02), // 👈 responsive radius
          ),

          border: const GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Colors.orange,
                Colors.green,
                Colors.grey,
                Colors.blue,
              ],
            ),
            width: 2,
          ),
        ),

        child: FadeTransition(
          opacity: _animation,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.orange[800],
              fontSize: AppSize.width(0.04), // 👈 responsive text
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}