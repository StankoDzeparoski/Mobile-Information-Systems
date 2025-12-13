import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/favorite_meal.dart';
import '../models/meal.dart';
import '../widgets/meal.dart';
import '../services/api.dart';
import 'mealDetails.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService favService = FavoritesService();
  final ApiService api = ApiService();

  List<FavoriteMeal> allFavorites = [];
  List<FavoriteMeal> displayed = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _listenFavorites();
  }

  void _listenFavorites() {
    favService.getFavorites().listen((list) {
      setState(() {
        allFavorites = list;
        displayed = list;
        loading = false;
      });
    });
  }

  void _onSearch(String q) {
    if (q.isEmpty) {
      setState(() => displayed = allFavorites);
      return;
    }

    setState(() {
      displayed = allFavorites
          .where((m) => m.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  Future<void> _openMeal(FavoriteMeal fav) async {
    try {
      final full = await api.lookupMeal(fav.id);
      if (full != null) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(meal: full)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Meal not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert FavoriteMeal → MealModel for MealGrid
    final meals = displayed
        .map((f) => MealModel(id: f.id, name: f.name, thumb: f.thumb))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search favorites',
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
          : meals.isEmpty
          ? Center(child: Text('No favorites yet'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: MealGrid(
                meals: meals,
                onTap: (meal) {
                  final fav = displayed.firstWhere((f) => f.id == meal.id);
                  _openMeal(fav);
                },
                onFavorite: (meal) async {
                  await favService.removeFavorite(meal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed from favorites')),
                  );
                },
                isFavorite: (meal) => Future.value(true),
              ),
            ),
    );
  }
}
