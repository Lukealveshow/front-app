import 'dart:convert';
import 'package:http/http.dart' as http;
import 'services/config_service.dart';

class ApiService {
  static String get baseUrl => ConfigService.config.baseUrl;

  static Future<Map<String, dynamic>> login(String login, String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"login": login, "email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> saveData(
      String text,
      String context,
      String question,
      String translation,
      String language,
      String summary,
      String answer,
      String translatedText,
      String token,
  ) async {
    final url = Uri.parse("$baseUrl/save");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", 
      },
      body: jsonEncode({
      "text": text,
      "summary": summary,
      "context": context,
      "answer": answer,
      "question": question,
      "translation": translation,
      "language": language,
      "translated_text": translatedText,
    }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String login, String email, String password) async {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"login": login, "email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verify(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "code": code,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"status": "error", "message": "Erro na verificação"};
    }
  }
  static Future<Map<String, dynamic>> summarize(String text) async{
    final url = Uri.parse("$baseUrl/summarize");
    final response = await http.post(url, headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": text}),
    );
    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> answer(String context, String question) async{
    final url = Uri.parse("$baseUrl/answer");
    final response =  await http.post(url, headers: {"Content-Type": "application/json"},
    body: jsonEncode({"context": context, "question": question}),
    );
    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> translate(String text, String language) async{
    final url = Uri.parse("$baseUrl/translate");
    final response =  await http.post(url, headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": text, "language": language}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
  final url = Uri.parse("$baseUrl/forgot-password");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email}),
  );

  return jsonDecode(response.body);
}


  static Future<Map<String, dynamic>> resetPassword(String email, String code, String newPassword) async {
  final url = Uri.parse("$baseUrl/reset-password");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "code": code,
      "new_password": newPassword,
    }),
  );

  return jsonDecode(response.body);
}


  static Future<bool> checkStatus() async {
  try {
    final response = await http.get(Uri.parse("$baseUrl/status"));
    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    print("Erro ao conectar com API: $e");
  }
  return false;
}

}
