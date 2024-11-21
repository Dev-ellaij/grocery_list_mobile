import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:grocery_list_mobile/services/gemini_services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key, required String apiKey});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final GeminiService _geminiService = GeminiService();
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();

  String _recognizedText = "Say something...";
  bool _isListening = false;

  String? get suggestion => null;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  // Initialize TTS settings
  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate
    await _flutterTts.setPitch(1.0); // Adjust pitch
  }

  // Fetch AI suggestion for a task using Gemini API
  Future<void> fetchAISuggestion(String task, BuildContext context) async {
    try {
      // Call the Gemini API
      // String suggestion = await _geminiService.processTaskInstruction(task);

      // Ensure the context is still valid when showing the dialog
      if (context.mounted) {
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
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
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
  }

  // Start speech-to-text listening
  void _startListening() async {
    bool available = await _speechToText.initialize(
      onError: _handleSpeechError,
      onStatus: (status) => print("Speech status: $status"),
    );
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = "Listening...";
      });
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          if (result.finalResult) {
            fetchAISuggestion(result.recognizedWords, context);
          }
        },
      );
    } else {
      setState(() => _recognizedText = "Speech recognition not available.");
    }
  }

  // Stop speech-to-text listening
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _recognizedText = "Stopped listening.";
    });
  }

  // Handle speech recognition errors
  void _handleSpeechError(SpeechRecognitionError error) {
    setState(() {
      _recognizedText = "Error: ${error.errorMsg}";
    });
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Speech Recognition Error"),
          content: Text("Error: ${error.errorMsg}"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // No app bar as requested
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
              onPressed: _isListening ? null : _startListening,
              child: const Text("Start Speaking"),
            ),
            const SizedBox(height: 10),
            // Button to stop speech-to-text
            ElevatedButton(
              onPressed: !_isListening ? null : _stopListening,
              child: const Text("Stop Listening"),
            ),
          ],
        ),
      ),
    );
  }
}
