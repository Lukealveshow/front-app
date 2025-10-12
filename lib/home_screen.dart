import 'package:flutter/material.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final TextEditingController contextController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController translateController = TextEditingController();

  String summary = "";
  String answer = "";
  String translated = "";
  String language = "pt-BR";
  String uiLanguage = "pt";

  String appTheme = "White";

  Color get backgroundColor {
    switch (appTheme) {
      case "Dark":
        return Colors.grey.shade900;
      case "Light":
        return Colors.purple.shade50;
      case "White":
      default:
        return Colors.white;
    }
  }

  Color get textColor {
    switch (appTheme) {
      case "Dark":
        return Colors.white;
      default:
        return Colors.black87;
    }
  }

  final Map<String, Map<String, String>> translations = {
    "pt": {
      "title": "Bem Vindo ao MAKENLP",
      "summarize": "Texto para Sumarização",
      "context": "Texto para gerar Resposta",
      "question": "Pergunta para a IA",
      "translate": "Tradução Textual",
      "send": "Enviar",
      "sendAll": "Enviar Tudo",
      "summary": "Resumo",
      "answer": "Resposta",
      "translated": "Tradução",
    },
    "en": {
      "title": "Welcome to MAKENLP",
      "summarize": "Text for Summarization",
      "context": "Text for Answer Generation",
      "question": "Question for AI",
      "translate": "Text Translation",
      "send": "Send",
      "sendAll": "Send All",
      "summary": "Summary",
      "answer": "Answer",
      "translated": "Translation",
    },
    "es": {
      "title": "Bienvenido a MAKENLP",
      "summarize": "Texto para Resumir",
      "context": "Texto para Generar Respuesta",
      "question": "Pregunta para la IA",
      "translate": "Traducción de Texto",
      "send": "Enviar",
      "sendAll": "Enviar Todo",
      "summary": "Resumen",
      "answer": "Respuesta",
      "translated": "Traducción",
    },
    "fr": {
      "title": "Bienvenue à MAKENLP",
      "summarize": "Texte à Résumer",
      "context": "Texte pour Générer une Réponse",
      "question": "Question pour l'IA",
      "translate": "Traduction de Texte",
      "send": "Envoyer",
      "sendAll": "Tout Envoyer",
      "summary": "Résumé",
      "answer": "Réponse",
      "translated": "Traduction",
    },
  };

  final Map<String, Map<String, String>> languageNames = {
    "pt": {"en": "Inglês", "es": "Espanhol", "fr": "Francês", "pt-BR": "Português"},
    "en": {"en": "English", "es": "Spanish", "fr": "French", "pt-BR": "Portuguese"},
    "es": {"en": "Inglés", "es": "Español", "fr": "Francés", "pt-BR": "Portugués"},
    "fr": {"en": "Anglais", "es": "Espagnol", "fr": "Français", "pt-BR": "Portugais"},
  };

  @override
  Widget build(BuildContext context) {
    final t = translations[uiLanguage]!;
    final langNames = languageNames[uiLanguage]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: "Sair",
                  icon: Image.asset(
                    'assets/signout.png',
                    width: 32,
                    height: 32,
                    color: textColor, 
                  ),
                  onPressed: () async {
                    await clearToken();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/makenlp.png', height: 100),
                    const SizedBox(height: 6),
                    Text(
                      t["title"]!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      tooltip: "Tema",
                      icon: const Icon(Icons.color_lens, size: 32),
                      color: textColor,
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                          items: [
                            PopupMenuItem(
                              onTap: () => setState(() => appTheme = "White"),
                              child: const Text("White"),
                            ),
                            PopupMenuItem(
                              onTap: () => setState(() => appTheme = "Dark"),
                              child: const Text("Dark"),
                            ),
                            PopupMenuItem(
                              onTap: () => setState(() => appTheme = "Light"),
                              child: const Text("Light"),
                            ),
                          ],
                        );
                      },
                    ),

                    IconButton(
                      tooltip: "Idioma",
                      icon: Image.asset(
                        'assets/translate.png',
                        width: 32,
                        height: 32,
                        color: textColor, 
                      ),
                      onPressed: () {
                        showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                          items: [
                            PopupMenuItem(onTap: () => setState(() => uiLanguage = "pt"), child: const Text("Português")),
                            PopupMenuItem(onTap: () => setState(() => uiLanguage = "en"), child: const Text("English")),
                            PopupMenuItem(onTap: () => setState(() => uiLanguage = "es"), child: const Text("Español")),
                            PopupMenuItem(onTap: () => setState(() => uiLanguage = "fr"), child: const Text("Français")),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
            padding: const EdgeInsets.only(left: 160), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextField(
                    controller: textController,
                    style: TextStyle(color: textColor), 
                    decoration: InputDecoration(
                      labelText: t["summarize"],
                      labelStyle: TextStyle(color: textColor),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await ApiService.summarize(textController.text);
                    setState(() => summary = result["summary"] ?? "");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: textColor, 
                    backgroundColor: appTheme == "Dark" ? Colors.grey.shade800 : null,
                  ),
                  child: Text(t["send"]!),
                ),
              ],
            ),
            ),
            const SizedBox(height: 24),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${t["summary"]}: $summary",
                style: TextStyle(color: textColor),
              ),
            ),
          ),
            const SizedBox(height: 50),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              child: TextField(
                controller: contextController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: t["context"],
                  labelStyle: TextStyle(color: textColor),
                ),
                maxLines: null,
              ),
            ),
          ),
            const SizedBox(height: 16),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextField(
                    controller: questionController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: t["question"],
                      labelStyle: TextStyle(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await ApiService.answer(contextController.text, questionController.text);
                    setState(() => answer = result["answer"] ?? "");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: appTheme == "Dark" ? Colors.grey.shade800 : null,
                  ),
                  child: Text(t["send"]!),
                ),
              ],
            ),
          ),
            const SizedBox(height: 24),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${t["answer"]}: $answer",
                style: TextStyle(color: textColor),
              ),
            ),
          ),

            const SizedBox(height: 50),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextField(
                    controller: translateController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: t["translate"],
                      labelStyle: TextStyle(color: textColor),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await ApiService.translate(translateController.text, language);
                    setState(() => translated = result["translated"] ?? "");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: appTheme == "Dark" ? Colors.grey.shade800 : null,
                  ),
                  child: Text(t["send"]!),
                ),
              ],
            ),
            ),
            const SizedBox(height: 16),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: DropdownButton<String>(
              value: language,
              dropdownColor: backgroundColor,
              style: TextStyle(color: textColor),
              items: langNames.entries.map((entry) {
                return DropdownMenuItem(value: entry.key, child: Text(entry.value, style: TextStyle(color: textColor)));
              }).toList(),
              onChanged: (value) => setState(() => language = value!),
            ),
          ),
            const SizedBox(height: 24),
            Padding(
            padding: const EdgeInsets.only(left: 160),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.60,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "${t["translated"]}: $translated",
                style: TextStyle(color: textColor),
              ),
            ),
          ),

            const SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final token = await getSavedToken();
                  final result = await ApiService.saveData(
                    textController.text,
                    contextController.text,
                    questionController.text,
                    translateController.text,
                    language,
                    summary,
                    answer,
                    translated,
                    token,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result["message"] ?? "Erro ao salvar")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: textColor,
                  backgroundColor: appTheme == "Dark" ? Colors.grey.shade800 : null,
                ),
                child: Text(t["sendAll"]!),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
