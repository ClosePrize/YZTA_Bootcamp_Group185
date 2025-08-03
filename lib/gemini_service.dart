import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

  static Future<String> summarizeText(String input) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Aşağıdaki tıbbi notu özetle:\n\n$input"}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return content ?? 'Özet bulunamadı.';
    } else {
      throw Exception('Gemini API hatası: ${response.statusCode}');
    }
  }
}
