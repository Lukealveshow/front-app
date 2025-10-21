import 'package:flutter/material.dart';
import 'reset_password.dart';
import 'api_service.dart';
import 'main.dart';
import 'services/language_selector.dart';
import 'services/language_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _loginController = TextEditingController();

  void _sendCode() async {
    final result = await ApiService.forgotPassword(_loginController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? LanguageService.t("error"))),
    );

    if (result['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(login: _loginController.text.trim()),
        ),
      );
    }
  }

  Widget voltarParaLoginButton(BuildContext context) {
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
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        },
        child: Text(
          LanguageService.t("back_to_login"),
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              LanguageService.t("forgot_password"),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
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
                    Image.asset('assets/login.png', height: 150, fit: BoxFit.contain),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _loginController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: LanguageService.t("email"),
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
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                          foregroundColor: Colors.cyanAccent,
                          side: const BorderSide(color: Colors.cyanAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _sendCode,
                        child: Text(LanguageService.t("send_code")),
                      ),
                    ),
                    const SizedBox(height: 16),
                    voltarParaLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
