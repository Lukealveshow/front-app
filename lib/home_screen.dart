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
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/signout.png', width: 28, height: 28),
          onPressed: () async {
            await clearToken();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
        title: Text(t["title"]!),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Image.asset('assets/translate.png', width: 28, height: 28),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                  items: [
                    PopupMenuItem(child: const Text("Português"), onTap: () => setState(() => uiLanguage = "pt")),
                    PopupMenuItem(child: const Text("English"), onTap: () => setState(() => uiLanguage = "en")),
                    PopupMenuItem(child: const Text("Español"), onTap: () => setState(() => uiLanguage = "es")),
                    PopupMenuItem(child: const Text("Français"), onTap: () => setState(() => uiLanguage = "fr")),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 40),

          // Bloco de Sumarização
          Row(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextField(
                controller: textController,
                decoration: InputDecoration(labelText: t["summarize"]),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await ApiService.summarize(textController.text);
                setState(() => summary = result["summary"] ?? "");
              },
              child: Text(t["send"]!),
            ),
          ]),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
            child: Text("${t["summary"]}: $summary"),
          ),

          const SizedBox(height: 35),

          // Bloco de Resposta
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: TextField(
              controller: contextController,
              decoration: InputDecoration(labelText: t["context"]),
              maxLines: null,
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: t["question"]),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await ApiService.answer(contextController.text, questionController.text);
                setState(() => answer = result["answer"] ?? "");
              },
              child: Text(t["send"]!),
            ),
          ]),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
            child: Text("${t["answer"]}: $answer"),
          ),

          const SizedBox(height: 35),

          // Bloco de Tradução
          Row(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextField(
                controller: translateController,
                decoration: InputDecoration(labelText: t["translate"]),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () async {
                final result = await ApiService.translate(translateController.text, language);
                setState(() => translated = result["translated"] ?? "");
              },
              child: Text(t["send"]!),
            ),
          ]),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: language,
            items: langNames.entries.map((entry) {
              return DropdownMenuItem(value: entry.key, child: Text(entry.value));
            }).toList(),
            onChanged: (value) => setState(() => language = value!),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
            child: Text("${t["translated"]}: $translated"),
          ),

          const SizedBox(height: 50),

          // Botão Enviar Tudo
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"] ?? "Erro ao salvar")));
              },
              child: Text(t["sendAll"]!),
            ),
          ),

          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}
