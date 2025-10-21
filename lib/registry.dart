import 'package:flutter/material.dart';
import 'package:makenlp/api_service.dart';
import 'package:makenlp/verify_screen.dart';
import 'services/language_selector.dart';
import 'services/language_service.dart';
class RegistryScreen extends StatefulWidget {
  const RegistryScreen({super.key});

  @override
  State<RegistryScreen> createState() => _RegistryScreenState();
}

class _RegistryScreenState extends State<RegistryScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() async {
    String login = _loginController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t("passwords_do_not_match"))),
      );
      return;
    }

    final result = await ApiService.register(login, email, password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? LanguageService.t("error"))),
    );

    if (result['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              LanguageService.t("create_account"),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.cyanAccent),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: LanguageSelector(),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF010A13),
                  Color(0xFF021B2E),
                  Color(0xFF041F3F),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField(_loginController, LanguageService.t("login")),
                    const SizedBox(height: 16),
                    _buildTextField(_emailController, LanguageService.t("email")),
                    const SizedBox(height: 16),
                    _buildTextField(_passwordController, LanguageService.t("password"), obscureText: true),
                    const SizedBox(height: 16),
                    _buildTextField(_confirmPasswordController, LanguageService.t("confirm_password"), obscureText: true),
                    const SizedBox(height: 32),
                    _buildButton(LanguageService.t("register"), _register),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.cyanAccent),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.25),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent.withOpacity(0.1),
          foregroundColor: Colors.cyanAccent,
          side: const BorderSide(color: Colors.cyanAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }
}
