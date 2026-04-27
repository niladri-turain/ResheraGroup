import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../provider/vendor_category_provider.dart';
import '../../widgets/vendor_category_item_widget.dart';

class VendorCategoryList extends StatefulWidget {
  final String categoryId;
  final String subCategoryId;
  final String vendorId;

  const VendorCategoryList({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
    required this.vendorId,
  });

  @override
  State<VendorCategoryList> createState() => _VendorCategoryListState();
}

class _VendorCategoryListState extends State<VendorCategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B2CBF),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Vendor Category List",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Consumer<VendorCategoryProvider>(
        builder: (context, catProvider, child) {
          if (catProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (catProvider.categories.isEmpty) {
            return const Center(child: Text("No categories found"));
          }
          return Container(
            padding: const EdgeInsets.only(top: 20, left: 16),
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: catProvider.categories.length,
              itemBuilder: (context, catIndex) {
                final category = catProvider.categories[catIndex];
                return VendorCategoryItemWidget(
                  name: category.name,
                  image: category.image ?? "",
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<VendorCategoryProvider>()
          .fetchVendorCategories(widget.categoryId, widget.subCategoryId,widget.vendorId);
    });
  }
}
