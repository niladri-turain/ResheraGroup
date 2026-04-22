import 'dart:ui';

class CategoryModel {
  final String title;
  final String image;
  final VoidCallback onTap;

  CategoryModel({
    required this.title,
    required this.image,
    required this.onTap,
  });
}