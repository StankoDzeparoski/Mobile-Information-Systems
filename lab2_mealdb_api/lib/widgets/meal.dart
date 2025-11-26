import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';

class MealGrid extends StatelessWidget {
  final List<MealModel> meals;
  final Function(MealModel) onTap;

  const MealGrid({required this.meals, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) return Center(child: Text('No meals found'));
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
      ),
      itemCount: meals.length,
      itemBuilder: (ctx, idx) {
        final m = meals[idx];
        return GestureDetector(
          onTap: () => onTap(m),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: m.thumb,
                    fit: BoxFit.cover,
                    placeholder: (c, s) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (c, s, e) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    m.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
