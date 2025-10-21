import 'package:flutter/material.dart';
import 'language_service.dart';

class LanguageSelector extends StatelessWidget {
  final Color textColor;
  const LanguageSelector({super.key, this.textColor = Colors.cyanAccent});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "Idioma",
      offset: const Offset(0, 50),
      color: const Color(0xFF021B2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.cyanAccent, width: 0.5),
      ),
      icon: Image.asset(
        'assets/translate.png',
        width: 32,
        height: 32,
        color: textColor,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "pt",
          child: Row(
            children: [
              Image.asset('assets/br.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text("Português", style: TextStyle(color: Colors.cyanAccent)),
            ],
          ),
        ),
        PopupMenuItem(
          value: "en",
          child: Row(
            children: [
              Image.asset('assets/english.png', width: 24, height: 24),
              const SizedBox(width: 8),
              const Text("English", style: TextStyle(color: Colors.cyanAccent)),
            ],
          ),
        ),
      ],
      onSelected: (langCode) {
        LanguageService.currentLanguage.value = langCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(langCode == "pt"
                ? "Idioma alterado para o Português"
                : "Language changed to English"),
          ),
        );
      },
    );
  }
}
