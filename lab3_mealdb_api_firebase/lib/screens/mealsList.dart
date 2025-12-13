import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/meal.dart';
import '../widgets/meal.dart';
import 'mealDetails.dart';
import '../services/favorites_service.dart';
import '../models/favorite_meal.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  MealsScreen({required this.category});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final favService = FavoritesService();
  final ApiService api = ApiService();
  List<MealModel> meals = [];
  List<MealModel> displayed = [];
  bool loading = true;

  Future<bool> _isFavorite(MealModel meal) {
    return favService.isFavorite(meal.id);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final list = await api.fetchMealsByCategory(widget.category);
      setState(() {
        meals = list;
        displayed = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  void _onSearch(String q) async {
    if (q.isEmpty) {
      setState(() => displayed = meals);
      return;
    }
    setState(() => loading = true);
    try {
      final results = await api.searchMeals(q);
      setState(() {
        // search returns full meals possibly from all categories; show them
        displayed = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  void _openMeal(MealModel m) async {
    try {
      final full = await api.lookupMeal(m.id);
      if (full != null) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(meal: full)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Meal not found.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search meals (global)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _onSearch,
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: MealGrid(
                meals: displayed,
                onTap: _openMeal,
                isFavorite: _isFavorite,
                onFavorite: (meal) async {
                  final isFav = await favService.isFavorite(meal.id);

                  if (isFav) {
                    await favService.removeFavorite(meal.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from favorites')),
                    );
                  } else {
                    await favService.addFavorite(FavoriteMeal.fromMeal(meal));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to favorites')),
                    );
                  }

                  setState(() {}); // refresh icons
                },
              ),
            ),
    );
  }
}
