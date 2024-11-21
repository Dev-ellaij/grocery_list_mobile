import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final ValueChanged<bool?> onChanged;
  final Function(BuildContext) deleteFunction;
  final VoidCallback speakTask;
  final VoidCallback fetchAISuggestion;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.speakTask,
    required this.fetchAISuggestion,
  });

  // Text-to-Speech instance for speaking task
  // ignore: unused_field
  final FlutterTts _flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.white,
      child: ListTile(
        leading: Checkbox(
          value: taskCompleted,
          onChanged: onChanged,
          activeColor: Colors.green,
        ),
        title: Text(
          taskName,
          style: TextStyle(
            decoration: taskCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.speaker_notes),
              onPressed: speakTask,
              tooltip: 'Speak Task',
            ),
            IconButton(
              icon: const Icon(Icons.lightbulb),
              onPressed: fetchAISuggestion,
              tooltip: 'Get AI Suggestion',
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => deleteFunction(context),
          tooltip: 'Delete Task',
        ),
      ),
    );
  }
}
