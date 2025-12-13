import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class MealGrid extends StatelessWidget {
  final List<MealModel> meals;
  final Function(MealModel) onTap;
  final Function(MealModel) onFavorite;
  final Future<bool> Function(MealModel) isFavorite;

  const MealGrid({
    required this.meals,
    required this.onTap,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return Center(child: Text('No meals found'));

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: meals.length,
      itemBuilder: (ctx, i) {
        final m = meals[i];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTap(m),
                  child: CachedNetworkImage(
                    imageUrl: m.thumb,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        m.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: isFavorite(m),
                      builder: (context, snapshot) {
                        final fav = snapshot.data ?? false;

                        return IconButton(
                          icon: Icon(
                            fav ? Icons.favorite : Icons.favorite_border,
                            color: fav ? Colors.red : null,
                          ),
                          onPressed: () => onFavorite(m),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
