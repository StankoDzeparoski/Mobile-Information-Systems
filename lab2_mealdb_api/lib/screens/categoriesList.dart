// lib/screens/categories_screen.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/category.dart';
import '../widgets/category.dart';
import 'mealsList.dart';
import 'mealDetails.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  List<CategoryModel> categories = [];
  List<CategoryModel> filtered = [];
  bool loading = true;
  String? lastError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      lastError = null;
    });
    try {
      debugPrint('CategoriesScreen: fetching categories...');
      final list = await api.fetchCategories();
      debugPrint('CategoriesScreen: fetched ${list.length} categories');
      setState(() {
        categories = list;
        filtered = list;
      });
    } catch (e, st) {
      debugPrint('CategoriesScreen: fetch error -> $e\n$st');
      setState(() {
        lastError = e.toString();
        categories = [];
        filtered = [];
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading categories: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  void _onSearch(String q) {
    if (q.isEmpty) {
      setState(() => filtered = categories);
      return;
    }
    setState(() {
      filtered = categories
          .where((c) => c.name.toLowerCase().contains(q.toLowerCase()))
          .toList();
    });
  }

  // void _openRandom() async {
  //   try {
  //     final meal = await api.randomMeal();
  //     Navigator.of(
  //       context,
  //     ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal!)));
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   }
  // }
  void _openRandom() async {
    try {
      final meal = await api.randomMeal();
      if (meal != null) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(meal: meal)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No meal found. Try again.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final webWarning = kIsWeb
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'If you run this in Flutter Web you may see empty results due to CORS. Try on an Android/iOS emulator or device.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [IconButton(onPressed: _openRandom, icon: Icon(Icons.casino))],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search categories',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _onSearch,
                ),
                SizedBox(height: 6),
                webWarning,
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : (filtered.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final c = filtered[i];
                        return CategoryCard(
                          category: c,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MealsScreen(category: c.name),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              lastError == null
                  ? 'No categories found.'
                  : 'Failed to load categories.\n\nError: $lastError',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _load,
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
            ),
            SizedBox(height: 8),
            Text(
              '.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
