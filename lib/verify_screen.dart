import 'package:flutter/material.dart';
import 'package:makenlp/api_service.dart';
import 'services/language_selector.dart';
import 'main.dart';
import 'services/language_service.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _verify() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t("enter_verification_code"))),
      );
      return;
    }

    final result = await ApiService.verify(widget.email, code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? LanguageService.t("error"))),
    );

    if (result['status'] == 'success') {
      Navigator.pop(context);
    }
  }

  Widget voltarButton(BuildContext context) {
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
        onPressed: () => Navigator.pop(context),
        child: Text(
          LanguageService.t("back"),
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
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
              LanguageService.t("email_verification"),
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
                    Text(
                      LanguageService.t("enter_code_sent_to"),
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.email,
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: width,
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
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
                    const SizedBox(height: 32),
                    SizedBox(width: width, child: _buildElevatedButton(LanguageService.t("verify"), _verify)),
                    const SizedBox(height: 16),
                    voltarButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyanAccent.withOpacity(0.1),
        foregroundColor: Colors.cyanAccent,
        side: const BorderSide(color: Colors.cyanAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }
}