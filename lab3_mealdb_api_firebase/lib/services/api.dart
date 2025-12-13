import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final resp = await http.get(Uri.parse('$base/categories.php'));

      if (resp.statusCode != 200) throw Exception('Failed to load categories');

      final data = json.decode(resp.body) as Map<String, dynamic>;
      final List list = data['categories'] as List;

      return list.map((i) => CategoryModel.fromJson(i)).toList();
    } catch (error) {
      print('Error fetching categories: $error');
      return [];
    }
  }

  Future<List<MealModel>> fetchMealsByCategory(String category) async {
    try {
      final resp = await http.get(
        Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}'),
      );

      if (resp.statusCode != 200) throw Exception('Failed to load meals');

      final data = json.decode(resp.body) as Map<String, dynamic>;
      if (data['meals'] == null) return [];

      final List list = data['meals'] as List;
      return list.map((i) => MealModel.fromListJson(i)).toList();
    } catch (error) {
      print('Error fetching meals by category: $error');
      return [];
    }
  }

  Future<List<MealModel>> searchMeals(String query) async {
    try {
      final resp = await http.get(
        Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}'),
      );

      if (resp.statusCode != 200) throw Exception('Search failed');

      final data = json.decode(resp.body) as Map<String, dynamic>;
      if (data['meals'] == null) return [];

      final List list = data['meals'] as List;
      return list.map((i) => MealModel.fromDetailJson(i)).toList();
    } catch (error) {
      print('Error searching meals: $error');
      return [];
    }
  }

  Future<MealModel?> lookupMeal(String id) async {
    try {
      final resp = await http.get(
        Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}'),
      );

      if (resp.statusCode != 200) return null;

      final data = json.decode(resp.body) as Map<String, dynamic>;
      final mealJson = (data['meals'] as List).first;
      return MealModel.fromDetailJson(mealJson);
    } catch (error) {
      print('Error looking up meal: $error');
      return null;
    }
  }

  Future<MealModel?> randomMeal() async {
    try {
      final resp = await http.get(Uri.parse('$base/random.php'));

      if (resp.statusCode != 200) return null;

      final data = json.decode(resp.body) as Map<String, dynamic>;
      final mealJson = (data['meals'] as List).first;
      return MealModel.fromDetailJson(mealJson);
    } catch (error) {
      print('Error fetching random meal: $error');
      return null;
    }
  }
}
