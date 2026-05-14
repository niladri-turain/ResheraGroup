import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../provider/main_vendor_banner_provider.dart';

class MainVendorSliderWidget extends StatefulWidget {
  final double? height;

  const MainVendorSliderWidget({
    super.key,
    this.height,
  });

  @override
  State<MainVendorSliderWidget> createState() => _MainVendorSliderWidgetState();
}

class _MainVendorSliderWidgetState extends State<MainVendorSliderWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainVendorBannerProvider>().fetchMainVendorBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final sliderHeight = widget.height ?? AppSize.height(0.22);

    return Consumer<MainVendorBannerProvider>(
      builder: (context, provider, child) {
        // if (provider.isLoading) {
        //   return Shimmer.fromColors(
        //     baseColor: Colors.grey[300]!,
        //     highlightColor: Colors.grey[100]!,
        //     child: Container(
        //       height: sliderHeight,
        //       margin: EdgeInsets.symmetric(horizontal: AppSize.width(0.03)),
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(AppSize.width(0.04)),
        //       ),
        //     ),
        //   );
        // }

        if (provider.bannerModel == null ||
            provider.bannerModel!.data == null ||
            provider.bannerModel!.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final banners = provider.bannerModel!.data!;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              items: banners.map((banner) {
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
                      image: NetworkImage(banner.image ?? ""),
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
            Positioned(
              bottom: AppSize.height(0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners.asMap().entries.map((entry) {
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
                          ?  Colors.grey
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
      },
    );
  }
}
