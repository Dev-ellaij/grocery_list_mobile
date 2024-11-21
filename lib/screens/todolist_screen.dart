// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:grocery_list_mobile/services/gemini_services.dart'; // Import the GeminiService
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final GeminiService _geminiService = GeminiService(); // Use GeminiService
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  // Define a variable to hold the transcribed text
  String _recognizedText = "Say something...";

  String? get suggestion => null;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  // Initialize TTS with desired settings
  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate
    await _flutterTts.setPitch(1.0); // Adjust pitch
  }

  // Fetch AI suggestion for a task using Gemini API
  Future<void> fetchAISuggestion(String task, BuildContext context) async {
    try {
      // Pause any ongoing TTS before fetching new suggestions
      await _flutterTts.pause();

      // Call the Gemini API
      // String suggestion = await _geminiService.processTaskInstruction(task);

      // Display suggestion in a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("AI Suggestion"),
          content: Text(suggestion!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Speak the suggestion
      await _flutterTts.speak("AI suggestion: $suggestion");
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to fetch AI suggestion: $e"),
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
      _speech.listen(onResult: (result) async {
        setState(() {
          _recognizedText = result.recognizedWords;
        });

        // Process recognized text after speech stops
        if (result.finalResult) {
          await fetchAISuggestion(_recognizedText, context);
        }
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
      appBar: null, // No app bar as requested
      backgroundColor:
          Colors.white, // You can customize the background color here
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
          ],
        ),
      ),
    );
  }
}
