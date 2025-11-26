import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/meal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MealDetailScreen extends StatelessWidget {
  final MealModel meal;
  MealDetailScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: meal.thumb,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (c, s) => Container(
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                if (meal.ingredients.isNotEmpty) ...[
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  ...meal.ingredients.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text('- ${e.key} : ${e.value}'),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
                if ((meal.instructions ?? '').isNotEmpty) ...[
                  Text(
                    'Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(meal.instructions!),
                  SizedBox(height: 12),
                ],
                if ((meal.youtube ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.video_library, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: meal.youtube!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Copied YouTube URL to clipboard',
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              meal.youtube!,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
