import 'package:flutter/material.dart';
import 'api_service.dart';
import 'main.dart';
import 'services/language_selector.dart';
import 'services/language_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String login;

  const ResetPasswordScreen({super.key, required this.login});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _resetPassword() async {
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t("passwords_do_not_match"))),
      );
      return;
    }

    final result = await ApiService.resetPassword(widget.login, code, newPassword);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? LanguageService.t("error"))),
    );

    if (result['status'] == 'success') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
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
        child: Text(LanguageService.t("back_to_login"),
            style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.4;

    return ValueListenableBuilder(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              LanguageService.t("reset_password"),
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
                      width: width,
                      child: TextField(
                        controller: _codeController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: LanguageService.t("verification_code"),
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: width,
                      child: TextField(
                        controller: _newPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: LanguageService.t("new_password"),
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: width,
                      child: TextField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: LanguageService.t("confirm_password"),
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
                    const SizedBox(height: 32),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                          foregroundColor: Colors.cyanAccent,
                          side: const BorderSide(color: Colors.cyanAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _resetPassword,
                        child: Text(LanguageService.t("reset_password")),
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
