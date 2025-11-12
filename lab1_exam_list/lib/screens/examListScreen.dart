import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../widgets/examCard.dart';

class ExamListScreen extends StatelessWidget {
  final String studentIndex = "221562";

  ExamListScreen({super.key});

  final List<Exam> exams = [
    Exam(
      name: "Математика 1",
      date: DateTime(2025, 11, 12, 9, 0),
      rooms: ["Lab 138", "Lab 112"],
    ),
    Exam(
      name: "Математика 3",
      date: DateTime(2025, 11, 3, 11, 0),
      rooms: ["Lab 2", "Lab 3"],
    ),
    Exam(
      name: "Математика 2",
      date: DateTime(2025, 11, 17, 10, 30),
      rooms: ["Lab 215", "Lab 200ab"],
    ),
    Exam(
      name: "Бази на податоци",
      date: DateTime(2025, 11, 19, 9, 0),
      rooms: ["Lab 200ab", "Lab 200v"],
    ),
    Exam(
      name: "Оперативни системи",
      date: DateTime(2025, 11, 21, 12, 0),
      rooms: ["Lab 138"],
    ),
    Exam(
      name: "Компјутерски мрежи и Безбедност",
      date: DateTime(2025, 11, 23, 9, 0),
      rooms: ["Lab 13"],
    ),
    Exam(
      name: "Алгоритми и Податочни Структури",
      date: DateTime(2025, 11, 25, 13, 0),
      rooms: ["Lab 13"],
    ),
    Exam(
      name: "Веб програмирање",
      date: DateTime(2025, 11, 27, 8, 30),
      rooms: ["Lab 13"],
    ),
    Exam(
      name: "Мобилни Информациски Системи",
      date: DateTime(2025, 11, 29, 10, 0),
      rooms: ["Lab 138", "Lab 112"],
    ),
    Exam(
      name: "Мобилни Платформи и Програмирање",
      date: DateTime(2025, 11, 1, 9, 0),
      rooms: ["Lab 3"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Подреди хронолошки
    exams.sort((a, b) => a.date.compareTo(b.date));

    return Scaffold(
      appBar: AppBar(
        title: Text("Распоред за испити - $studentIndex"),
        backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) => ExamCard(exam: exams[index]),
            ),
          ),
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, color: Colors.black),
                const SizedBox(width: 10),
                Text(
                  "Вкупно испити: ${exams.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
