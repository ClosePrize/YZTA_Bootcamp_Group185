import 'package:flutter/material.dart';
import 'gemini_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  String _summary = '';
  bool _isLoading = false;

  Future<void> _summarize() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _summary = '';
    });

    try {
      final result = await GeminiService.summarizeText(inputText);
      setState(() => _summary = result);
    } catch (e) {
      setState(() => _summary = 'Bir hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tıbbi Not Özetleyici'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Tıbbi metni buraya girin...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _summarize,
              child: const Text('Özetle'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _summary,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
