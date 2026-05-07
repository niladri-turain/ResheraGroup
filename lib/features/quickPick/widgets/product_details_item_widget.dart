import 'package:flutter/material.dart';
import '../model/product_details_model.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
class ProductDetailsItemWidget extends StatefulWidget {
  final ProductData product;

  const ProductDetailsItemWidget({super.key, required this.product});

  @override
  State<ProductDetailsItemWidget> createState() => _ProductDetailsItemWidgetState();
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
    if (widget.product.variants != null && widget.product.variants!.isNotEmpty) {
      final primaryIndex = widget.product.variants!.indexWhere((v) => v.isPrimary == true);
      _selectedVariantIndex = primaryIndex != -1 ? primaryIndex : 0;
      _updateSelectedAttributesFromVariant();
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
          if (v.attributes?.any((a) => a.attributeName == other.attributeName && a.value == other.value) ?? false) {
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

      // Printing as requested
      final groups = _getAttributeGroups();
      final sizeKey = groups.keys.firstWhere((k) => k.toLowerCase().contains("size"), orElse: () => "");
      final colorKey = groups.keys.firstWhere((k) => k.toLowerCase().contains("color"), orElse: () => "");
      
      print("----------------------------------");
      if (attributeName.toLowerCase().contains("size")) {
        print("Size Selected: $value");
      } else if (attributeName.toLowerCase().contains("color")) {
        print("Color Selected: $value");
      } else {
        print("$attributeName Selected: $value");
      }
      print("Current Size: ${_selectedAttributes[sizeKey] ?? 'N/A'}");
      print("Current Color: ${_selectedAttributes[colorKey] ?? 'N/A'}");
      print("----------------------------------");
    }
  }

  Color _getColorFromValue(String value) {
    switch (value.toLowerCase()) {
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'navy': return const Color(0xFF000080);
      case 'green': return Colors.green;
      case 'black': return Colors.black;
      case 'white': return Colors.white;
      case 'yellow': return Colors.yellow;
      case 'pink': return Colors.pink;
      case 'purple': return Colors.purple;
      case 'grey': return Colors.grey;
      case 'orange': return Colors.orange;
      case 'brown': return Colors.brown;
      case 'teal': return Colors.teal;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final variant = widget.product.variants?[_selectedVariantIndex];
    final images = variant?.images ?? [];
    final attributes = variant?.attributes ?? [];

    // Get all available attributes from all variants
    final groups = _getAttributeGroups();
    final sizeKey = groups.keys.firstWhere((k) => k.toLowerCase().contains("size"), orElse: () => "");
    final colorKey = groups.keys.firstWhere((k) => k.toLowerCase().contains("color"), orElse: () => "");

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Images Slider
          Stack(
            children: [
              SizedBox(
                height: AppSize.height(0.45),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index ? const Color(0xFF7B2CBF) : Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(16),
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
                  style: const TextStyle(color: Color(0xFF7B2CBF), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.name ?? "",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: Color(0xFF7B2CBF), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Delivery on Tuesday, 15th Dec 2023",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Text(
                      "₹${variant?.finalPrice ?? widget.product.finalPrice}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "₹${variant?.mrp ?? widget.product.mrp}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${variant?.discount ?? widget.product.discount}% OFF",
                        style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                const Text("Select Size", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (sizeKey.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text("No sizes available", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  )
                else ...[
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groups[sizeKey]!.length,
                      itemBuilder: (context, index) {
                        final size = groups[sizeKey]![index];
                        final isSelected = _selectedAttributes[sizeKey] == size;
                        return GestureDetector(
                          onTap: () => _updateVariantByAttribute(sizeKey, size),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF7B2CBF) : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey[300]!),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              size,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (colorKey.isNotEmpty) ...[
                  Text(colorKey, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groups[colorKey]!.length,
                      itemBuilder: (context, index) {
                        final colorValue = groups[colorKey]![index];
                        final isSelected = _selectedAttributes[colorKey] == colorValue;
                        return GestureDetector(
                          onTap: () => _updateVariantByAttribute(colorKey, colorValue),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                 color: _getColorFromValue(colorValue),
                                shape: BoxShape.circle,
                                border: colorValue.toLowerCase() == 'white' ? Border.all(color: Colors.grey[300]!) : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Any other attributes
                ...groups.entries.where((e) => e.key != sizeKey && e.key != colorKey).map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: entry.value.length,
                          itemBuilder: (context, index) {
                            final val = entry.value[index];
                            final isSelected = _selectedAttributes[entry.key] == val;
                            return GestureDetector(
                              onTap: () => _updateVariantByAttribute(entry.key, val),
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF7B2CBF) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? const Color(0xFF7B2CBF) : Colors.grey[300]!),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  val,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
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
                const Text("Product Description", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                HtmlWidget(
                  variant?.longDescription ?? variant?.shortDescription ?? "No description available.",
                  textStyle: const TextStyle(color: Colors.black54, height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 100), // Spacing for bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
