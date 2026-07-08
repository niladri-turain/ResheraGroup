import 'dart:ui';

import 'package:flutter/material.dart';
import '../model/product_details_model.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductDetailsItemWidget extends StatefulWidget {
  final ProductData product;
  final bool isFashion;
  final Function(Variant variant) onVariantChanged;

  const ProductDetailsItemWidget({
    super.key,
    required this.product,
    this.isFashion = false,
    required this.onVariantChanged,
  });

  @override
  State<ProductDetailsItemWidget> createState() =>
      _ProductDetailsItemWidgetState();
}

class _ProductDetailsItemWidgetState extends State<ProductDetailsItemWidget> {
  int _selectedVariantIndex = 0;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final Map<String, String> _selectedAttributes = {};

  @override
  void initState() {
    super.initState();
    // Find primary variant if available
    if (widget.product.variants != null &&
        widget.product.variants!.isNotEmpty) {
      final primaryIndex =
          widget.product.variants!.indexWhere((v) => v.isPrimary == true);
      _selectedVariantIndex = primaryIndex != -1 ? primaryIndex : 0;
      _updateSelectedAttributesFromVariant();
      
      // Notify parent about initial variant
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onVariantChanged(widget.product.variants![_selectedVariantIndex]);
      });
    }
  }

  void _updateSelectedAttributesFromVariant() {
    final variant = widget.product.variants![_selectedVariantIndex];
    if (variant.attributes != null) {
      for (var attr in variant.attributes!) {
        if (attr.attributeName != null && attr.value != null) {
          _selectedAttributes[attr.attributeName!] = attr.value!;
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Map<String, List<String>> _getAttributeGroups() {
    if (widget.product.variants == null) return {};
    final groups = <String, Set<String>>{};
    for (var variant in widget.product.variants!) {
      if (variant.attributes != null) {
        for (var attr in variant.attributes!) {
          if (attr.attributeName != null && attr.value != null) {
            groups.putIfAbsent(attr.attributeName!, () => {}).add(attr.value!);
          }
        }
      }
    }
    return groups.map((key, value) => MapEntry(key, value.toList()));
  }

  bool _isAttributeValueAvailable(String attributeName, String value) {
    if (widget.product.variants == null) return false;

    return widget.product.variants!.any((v) {
      // 1. The variant must have the attribute value we are checking
      final matchesTarget = v.attributes?.any(
            (a) => a.attributeName == attributeName && a.value == value,
          ) ??
          false;

      if (!matchesTarget) return false;

      // 2. The variant must match all OTHER currently selected attributes
      for (var entry in _selectedAttributes.entries) {
        if (entry.key == attributeName) continue;

        final hasOtherAttr = v.attributes?.any(
              (a) => a.attributeName == entry.key && a.value == entry.value,
            ) ??
            false;

        if (!hasOtherAttr) return false;
      }

      return true;
    });
  }

  // Helper to find variant by attributes
  void _updateVariantByAttribute(String attributeName, String value) {
    if (widget.product.variants == null) return;

    final currentVariant = widget.product.variants![_selectedVariantIndex];

    // Attempt to keep other attributes of the currently selected variant
    final otherAttributes = currentVariant.attributes
            ?.where((a) => a.attributeName != attributeName)
            .toList() ??
        [];

    int bestMatchIndex = -1;
    int maxMatches = -1;

    for (int i = 0; i < widget.product.variants!.length; i++) {
      final v = widget.product.variants![i];
      // We must match the clicked attribute value
      final hasTargetAttr = v.attributes?.any(
            (a) => a.attributeName == attributeName && a.value == value,
          ) ??
          false;

      if (hasTargetAttr) {
        int matches = 0;
        for (var other in otherAttributes) {
          if (v.attributes?.any((a) =>
                  a.attributeName == other.attributeName &&
                  a.value == other.value) ??
              false) {
            matches++;
          }
        }
        // If we find a variant that matches more of our other attributes (like keeping color when changing size), we prefer it.
        if (matches > maxMatches) {
          maxMatches = matches;
          bestMatchIndex = i;
        }
      }
    }

    if (bestMatchIndex != -1) {
      setState(() {
        _selectedVariantIndex = bestMatchIndex;
        _updateSelectedAttributesFromVariant();
        _currentImageIndex = 0;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
      widget.onVariantChanged(widget.product.variants![_selectedVariantIndex]);
    }
  }

  Color _getColorFromValue(String value) {
    switch (value.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'navy':
        return const Color(0xFF000080);
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'grey':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final variant = widget.product.variants?[_selectedVariantIndex];
    final images = variant?.images ?? [];

    // Get all available attributes from all variants
    final groups = _getAttributeGroups();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images Slider
          Stack(
            children: [
              SizedBox(
                height: isTablet ? AppSize.height(0.6) : AppSize.height(0.45),
                child: images.isNotEmpty
                    ? PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index].imageLarge ?? "",
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 50),
                            ),
                          );
                        },
                      )
                    : Image.network(
                        widget.product.image ?? "",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50),
                        ),
                      ),
              ),
              if (images.length > 1)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40 : AppSize.width(0.04),
              vertical: AppSize.width(0.04),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            transform: Matrix4.translationValues(0, -24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.business?.businessName ?? "",
                  style: TextStyle(
                      color: const Color(0xFF7B2CBF), 
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 20 : 14),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.name ?? "",
                  style: TextStyle(
                      fontSize: isTablet ? 28 : 20, 
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          color: Color(0xFF7B2CBF), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Delivery on Today",
                      style: TextStyle(color: Colors.grey, fontSize: isTablet ? 16 : 12),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Text(
                      "₹${variant?.finalPrice ?? widget.product.finalPrice}",
                      style: TextStyle(
                          fontSize: isTablet ? 32 : 22, 
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${variant?.mrp ?? widget.product.mrp}",
                      style: TextStyle(
                        fontSize: isTablet ? 22 : 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${variant?.discount ?? widget.product.discount}% OFF",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: isTablet ? 16 : 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Any attributes
                ...groups.entries.map((entry) {
                  final attributeName = entry.key;
                  final isColor = attributeName.toLowerCase().contains("color");
                  final isSize = attributeName.toLowerCase().contains("size");
                  final isCircle = widget.isFashion && isSize;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(attributeName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 20 : 16)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: isColor ? (isTablet ? 70 : 50) : (isTablet ? 60 : 40),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: entry.value.length,
                          itemBuilder: (context, index) {
                            final val = entry.value[index];
                            final isSelected =
                                _selectedAttributes[attributeName] == val;
                            final isAvailable =
                                _isAttributeValueAvailable(attributeName, val);

                            if (isColor) {
                              return GestureDetector(
                                onTap: () => _updateVariantByAttribute(
                                    attributeName, val),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Container(
                                    width: isTablet ? 45 : 32,
                                    height: isTablet ? 45 : 32,
                                    decoration: BoxDecoration(
                                      color: _getColorFromValue(val),
                                      shape: BoxShape.circle,
                                      border: val.toLowerCase() == 'white'
                                          ? Border.all(color: Colors.grey[300]!)
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return GestureDetector(
                              onTap: isAvailable
                                  ? () => _updateVariantByAttribute(
                                      attributeName, val)
                                  : null,
                              child: Opacity(
                                opacity: isAvailable ? 1.0 : 0.4,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isCircle ? 0 : (isTablet ? 24 : 16)),
                                  width: isCircle ? (isTablet ? 50 : 40) : null,
                                  height: isTablet ? 50 : 40,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7B2CBF)
                                        : Colors.white,
                                    shape: isCircle
                                        ? BoxShape.circle
                                        : BoxShape.rectangle,
                                    borderRadius: isCircle
                                        ? null
                                        : BorderRadius.circular(20),
                                    border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF7B2CBF)
                                            : Colors.grey[300]!),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    val,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: isTablet ? 16 : 12,
                                      decoration: isAvailable
                                          ? TextDecoration.none
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),

                const Divider(height: 32),
                Text("Product Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 20 : 16)),
                const SizedBox(height: 8),
                HtmlWidget(
                  variant?.longDescription ??
                      variant?.shortDescription ??
                      "No description available.",
                  textStyle: TextStyle(
                      color: Colors.black54, height: 1.5, fontSize: isTablet ? 18 : 14),
                ),
                const SizedBox(height: 150), // Spacing for bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }

}
