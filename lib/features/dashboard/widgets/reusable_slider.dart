import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';


class ReusableImageSlider extends StatefulWidget {
  final List<String> imagePaths;
  final double? height; // 👈 optional

  const ReusableImageSlider({
    super.key,
    required this.imagePaths,
    this.height,
  });

  @override
  State<ReusableImageSlider> createState() => _ReusableImageSliderState();
}

class _ReusableImageSliderState extends State<ReusableImageSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    AppSize.init(context); // 👈 important

    final sliderHeight = widget.height ?? AppSize.height(0.22);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [

        /// 1. Slider
        CarouselSlider(
          items: widget.imagePaths.map((img) {
            return Container(
              width: AppSize.screenWidth,
              margin: EdgeInsets.symmetric(
                horizontal: AppSize.width(0.03),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppSize.width(0.04),
                ),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }).toList(),

          options: CarouselOptions(
            height: sliderHeight,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        /// 2. Dots Indicator
        Positioned(
          bottom: AppSize.height(0.015),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imagePaths.asMap().entries.map((entry) {

              bool isSelected = currentIndex == entry.key;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: AppSize.width(0.015),
                height: AppSize.width(0.015),
                margin: EdgeInsets.symmetric(
                  horizontal: AppSize.width(0.01),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange
                      : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(
                    AppSize.width(0.02),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}