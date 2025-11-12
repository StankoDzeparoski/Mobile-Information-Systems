import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../screens/examDetailScreen.dart';
import 'package:intl/intl.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;

  const ExamCard({Key? key, required this.exam}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPast = exam.date.isBefore(DateTime.now());
    final formattedDate = DateFormat('dd.MM.yyyy').format(exam.date);
    final formattedTime = DateFormat('HH:mm').format(exam.date);

    return Card(
      color: isPast ? Colors.red.shade300 : Colors.blue.shade100,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        leading: Icon(
          isPast ? Icons.check_circle : Icons.schedule,
          color: isPast ? Colors.yellow : Colors.green,
        ),
        title: Text(
          exam.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text('$formattedDate, $formattedTime'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.room, size: 16),
                const SizedBox(width: 4),
                Text(exam.rooms.join(', ')),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
          );
        },
      ),
    );
  }
}
