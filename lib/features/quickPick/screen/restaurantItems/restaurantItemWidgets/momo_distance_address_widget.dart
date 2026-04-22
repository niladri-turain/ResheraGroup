import 'package:flutter/material.dart';

class LocationInfoRow extends StatelessWidget {
  final String distance;
  final String area;
  final String time;

  const LocationInfoRow({
    super.key,
    required this.distance,
    required this.area,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// 📍 ICON
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Colors.grey,
        ),

        const SizedBox(width: 4),

        /// DISTANCE
        Text(
          distance,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),

        const SizedBox(width: 6),

        /// DOT
        _dot(),

        const SizedBox(width: 6),

        /// AREA
        Text(
          area,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),

        const SizedBox(width: 6),

        /// DOT
        _dot(),

        const SizedBox(width: 6),

        /// TIME (Purple)
        Text(
          time,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.purple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _dot() {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}