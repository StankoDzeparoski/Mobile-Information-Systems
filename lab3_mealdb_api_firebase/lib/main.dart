import 'package:flutter/material.dart';
import 'package:lab3_mealdb_api_firebase/services/notification_service.dart';
import 'screens/categoriesList.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await Firebase.initializeApp();
  runApp(MealApp());
}

class MealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CategoriesScreen(),
    );
  }
}
