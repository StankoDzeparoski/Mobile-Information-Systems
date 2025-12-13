import 'package:lab3_mealdb_api_firebase/models/meal.dart';

class FavoriteMeal {
  final String id;
  final String name;
  final String thumb;

  FavoriteMeal({required this.id, required this.name, required this.thumb});

  factory FavoriteMeal.fromMeal(MealModel meal) {
    return FavoriteMeal(id: meal.id, name: meal.name, thumb: meal.thumb);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'thumb': thumb};

  factory FavoriteMeal.fromJson(Map<String, dynamic> json) {
    return FavoriteMeal(
      id: json['id'],
      name: json['name'],
      thumb: json['thumb'],
    );
  }
}
