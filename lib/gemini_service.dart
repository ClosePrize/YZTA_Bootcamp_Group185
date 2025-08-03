import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> summarizeText(String input) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': apiKey,  // API key burada header olarak
      },
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
      throw Exception('Gemini API hatası: ${response.statusCode} - ${response.body}');
    }
  }
}
