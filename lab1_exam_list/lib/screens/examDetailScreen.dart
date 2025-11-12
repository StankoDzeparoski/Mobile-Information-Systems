import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({super.key, required this.exam});

  String getTimeRemaining() {
    final now = DateTime.now();
    if (exam.date.isBefore(now)) return "Испитот е завршен.";

    final diff = exam.date.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    return "Време до испит $days дена, $hours часа.";
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy').format(exam.date);
    final formattedTime = DateFormat('HH:mm').format(exam.date);

    return Scaffold(
      appBar: AppBar(
        title: Text("Информации за испит"),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 8),
                    Text("Датум: $formattedDate"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text("Време: $formattedTime"),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.room),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("Простории: ${exam.rooms.join(', ')}"),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),
                Text(
                  getTimeRemaining(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
