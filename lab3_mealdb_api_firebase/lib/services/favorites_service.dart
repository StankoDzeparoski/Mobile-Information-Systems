import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal.dart';

class FavoritesService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'favorites';

  Stream<List<FavoriteMeal>> getFavorites() {
    return _db
        .collection(_collection)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => FavoriteMeal.fromJson(d.data())).toList(),
        );
  }

  Future<void> addFavorite(FavoriteMeal meal) async {
    await _db.collection(_collection).doc(meal.id).set(meal.toJson());
  }

  Future<void> removeFavorite(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<bool> isFavorite(String id) async {
    final list = await getFavorites().first;
    return list.any((m) => m.id == id);
  }
}
