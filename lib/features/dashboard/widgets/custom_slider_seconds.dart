import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomSliderSeconds extends StatefulWidget {
  const CustomSliderSeconds({super.key});

  @override
  State<CustomSliderSeconds> createState() => _CustomSliderSecondsState();
}

class _CustomSliderSecondsState extends State<CustomSliderSeconds> {
  int currentIndex = 0;

  final List<String> images = [
    "assets/images/slide1.png",
    "assets/images/slide4.png",
    "assets/images/slide5.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        CarouselSlider(
          items: images.map((img) {
            return Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.98,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        //  Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return Container(
              width: currentIndex == entry.key ? 10 : 6,
              height: currentIndex == entry.key ? 10 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: currentIndex == entry.key
                    ? Colors.orange
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}