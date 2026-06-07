import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';

class RecipeShimmerCard extends StatelessWidget {
  const RecipeShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: 180,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 16, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Container(height: 22, width: 60, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 100, color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(height: 12, width: 50, color: Colors.white),
                      const SizedBox(width: 10),
                      Container(height: 12, width: 60, color: Colors.white),
                      const SizedBox(width: 10),
                      Container(height: 12, width: 30, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
