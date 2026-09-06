import 'package:flutter/material.dart';
import 'package:latifa_almaneea_project2/const/app_color.dart';

import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index; 
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('sport')) return Icons.sports_soccer_rounded;
    if (n.contains('film')) return Icons.movie_rounded;
    if (n.contains('music')) return Icons.music_note_rounded;
    if (n.contains('science') || n.contains('nature'))
      return Icons.science_rounded;
    if (n.contains('history')) return Icons.account_balance_rounded;
    if (n.contains('geography')) return Icons.public_rounded;
    if (n.contains('animal')) return Icons.pets_rounded;
    if (n.contains('video game')) return Icons.videogame_asset_rounded;
    if (n.contains('book')) return Icons.menu_book_rounded;
    if (n.contains('art')) return Icons.palette_rounded;
    if (n.contains('mythology')) return Icons.castle_rounded;
    if (n.contains('television') || n.contains('tv')) return Icons.tv_rounded;
    if (n.contains('celebrit')) return Icons.star_rounded;
    if (n.contains('comic')) return Icons.auto_stories_rounded;
    if (n.contains('computer')) return Icons.computer_rounded;
    if (n.contains('math')) return Icons.calculate_rounded;
    if (n.contains('vehicle')) return Icons.directions_car_rounded;
    if (n.contains('anime') || n.contains('manga'))
      return Icons.animation_rounded;
    if (n.contains('cartoon')) return Icons.emoji_emotions_rounded;
    if (n.contains('board game')) return Icons.casino_rounded;
    return Icons.quiz_rounded;
  }

  String _cleanName(String name) {
    return name.contains(':') ? name.split(':').last.trim() : name;
  }

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.categoryPalette[index % AppColors.categoryPalette.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconFor(category.name), color: color, size: 34),
            ),
            const SizedBox(height: 14),
            Text(
              _cleanName(category.name),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
