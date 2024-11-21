import 'package:flutter/material.dart';
import 'package:grocery_list_mobile/widgets/task_page.dart'; // Import TaskPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String apiKey =
      "your_gemini_api_key_here"; // Replace with your Gemini API key

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Task App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskPage(apiKey: apiKey), // Use the TaskPage here
    );
  }
}
