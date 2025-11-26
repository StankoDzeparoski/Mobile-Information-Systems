class MealModel {
  final String id;
  final String name;
  final String thumb;
  final String? youtube;
  final String? instructions;
  final Map<String, String> ingredients; // ingredient -> measure

  MealModel({
    required this.id,
    required this.name,
    required this.thumb,
    this.youtube,
    this.instructions,
    Map<String, String>? ingredients,
  }) : ingredients = ingredients ?? {};

  // used for list endpoints (filter.php) which only return id, name, thumb
  factory MealModel.fromListJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
    );
  }

  // used for lookup/random/search which return full meal details
  factory MealModel.fromDetailJson(Map<String, dynamic> json) {
    final Map<String, String> ingr = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient =
          (json['strIngredient\$i'.replaceAll('\$i', i.toString())] ?? '')
              .toString()
              .trim();
      final measure =
          (json['strMeasure\$i'.replaceAll('\$i', i.toString())] ?? '')
              .toString()
              .trim();
      if (ingredient.isNotEmpty) {
        ingr[ingredient] = measure;
      }
    }

    // Because interpolation inside the key is awkward above, do the robust way:
    if (ingr.isEmpty) {
      for (int i = 1; i <= 20; i++) {
        final ingKey = 'strIngredient\$i'.replaceAll('\$i', i.toString());
        final measureKey = 'strMeasure\$i'.replaceAll('\$i', i.toString());
        final ingredient = (json[ingKey] ?? '').toString().trim();
        final measure = (json[measureKey] ?? '').toString().trim();
        if (ingredient.isNotEmpty) ingr[ingredient] = measure;
      }
    }

    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'],
      instructions: json['strInstructions'],
      ingredients: ingr,
    );
  }
}
