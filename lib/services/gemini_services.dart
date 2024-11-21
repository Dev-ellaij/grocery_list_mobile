import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:grocery_list_mobile/screens/todolist_screen.dart';
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // Speech-to-text package

// ignore: unused_element
class _HomePageState extends State<HomePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final GeminiService _geminiService =
      GeminiService(); // Initialize the Gemini service

  String _recognizedText = "Say something...";

  // Fetch Gemini suggestion for a task
  Future<void> fetchAISuggestion(String task, BuildContext context) async {
    try {
      // Call the Gemini API
      String suggestion = await _geminiService.fetchSuggestion(task);

      // Display suggestion in a dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Gemini Suggestion"),
          content: Text(suggestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Speak the suggestion
      _flutterTts.speak("Gemini suggestion: $suggestion");
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to fetch suggestion: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Start speech-to-text listening
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _recognizedText = "Listening...");
      _speech.listen(onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
        // Process the recognized text as a task for AI suggestion
        fetchAISuggestion(_recognizedText, context);
      });
    } else {
      setState(() => _recognizedText = "Speech recognition not available.");
    }
  }

  // Stop speech-to-text listening
  void _stopListening() {
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Task Assistant"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the recognized text from speech-to-text
            Text(
              _recognizedText,
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            const SizedBox(height: 20),
            // Button to start speech-to-text
            ElevatedButton(
              onPressed: _startListening,
              child: const Text("Start Speaking"),
            ),
            const SizedBox(height: 10),
            // Button to stop speech-to-text
            ElevatedButton(
              onPressed: _stopListening,
              child: const Text("Stop Listening"),
            ),
            const SizedBox(height: 20),
            // Button to manually trigger task processing (for testing)
            ElevatedButton(
              onPressed: () => fetchAISuggestion(_recognizedText, context),
              child: const Text("Get AI Suggestion"),
            ),
          ],
        ),
      ),
    );
  }
}

class GeminiService {
  Future<String> fetchSuggestion(String task) async {
    // Simulating an API request with a mock response
    await Future.delayed(const Duration(seconds: 2));
    return "To complete the task: '$task', follow these steps:\n1. Step 1\n2. Step 2\n3. Step 3";
  }

  void processTaskInstruction(String taskName) {
    // Logic for processing task instructions (if needed)
  }
}
