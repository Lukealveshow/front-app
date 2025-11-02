import 'package:flutter/material.dart';
import 'package:makenlp/dev_screen.dart';
import 'package:makenlp/help_screen.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'services/language_service.dart';
import 'profile_screen.dart';
import 'help_screen.dart';
import 'dev_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _settingsKey = GlobalKey();
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

  String loggedUser = "";
  bool apiOnline = false;
  IO.Socket? socket;

  Color get backgroundColor {
    switch (appTheme) {
      case "Dark":
        return Colors.transparent;
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
        return Colors.cyanAccent;
      default:
        return Colors.black87;
    }
  }

  Color get fieldFillColor {
    switch (appTheme) {
      case "Dark":
        return Colors.black.withOpacity(0.25);
      default:
        return Colors.white;
    }
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _loadFooterInfo();
  }

  Future<void> _loadFooterInfo() async {
    String? user = await StorageService.getUserLogin();
    setState(() {
      loggedUser = user ?? "";
    });
  }

  void _connectSocket() {
    socket = IO.io(
      ApiService.baseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
      },
    );

    socket!.onConnect((_) {
      print('Conectado ao WebSocket');
      setState(() => apiOnline = true);
    });

    socket!.onDisconnect((_) {
      print('Desconectado do WebSocket');
      setState(() => apiOnline = false);
    });

    socket!.onReconnect((attempt) {
      print('Tentativa de reconexão #$attempt');
    });

    socket!.onReconnectError((err) {
      print('Erro ao reconectar: $err');
    });

    socket!.on('api_status', (data) {
      if (!mounted) return;
      setState(() {
        apiOnline = data['online'] as bool;
      });
    });

    socket!.onConnectError((err) {
      print('Erro de conexão: $err');
      setState(() => apiOnline = false);
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
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
      "clean": "Limpar",
      "profile": "Perfil",
      "help": "Ajuda",
      "developer": "Desenvolvedor",
      "login": "Login",
      "email": "E-mail",
      "password": "Senha",
      "reset_password": "Redefinir Senha",
      "home": "Voltar à Home",
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
      "clean": "Clean",
      "profile": "Profile",
      "help": "Help",
      "developer": "Developer",
      "login": "Login",
      "email": "Email",
      "password": "Password",
      "reset_password": "Reset Password",
      "home": "Back to Home",
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
      "clean": "Limpiar",
      "profile": "Perfil",
      "help": "Ayuda",
      "developer": "Programador",
      "login": "Usuario",
      "email": "Correo",
      "password": "Contraseña",
      "reset_password": "Restablecer Contraseña",
      "home": "Volver a Inicio",
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
      "clean": "Effacer",
      "profile": "Profil",
      "help": "Aide",
      "developer": "Développeur",
      "login": "Login",
      "email": "E-mail",
      "password": "Mot de passe",
      "reset_password": "Réinitialiser le mot de passe",
      "home": "Retour à l'accueil",
    },
  };

  final List<Map<String, String>> languagesList = [
    {"code": "pt-BR", "name": "Português"},
    {"code": "en", "name": "Inglês"},
    {"code": "es", "name": "Espanhol"},
    {"code": "fr", "name": "Francês"},
  ];

  final Map<String, Map<String, String>> languageNames = {
    "pt": {
      "pt-BR": "Português",
      "en": "Inglês",
      "es": "Espanhol",
      "fr": "Francês",
    },
    "en": {
      "pt-BR": "Portuguese",
      "en": "English",
      "es": "Spanish",
      "fr": "French",
    },
    "es": {
      "pt-BR": "Portugués",
      "en": "Inglés",
      "es": "Español",
      "fr": "Francés",
    },
    "fr": {
      "pt-BR": "Portugais",
      "en": "Anglais",
      "es": "Espagnol",
      "fr": "Français",
    },
  };

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: fieldFillColor,
    );
  }

  Widget _buildFieldWithButton(
      TextEditingController controller, String label, VoidCallback onPressed) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor),
            decoration: _buildInputDecoration(label),
            maxLines: null,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor:
                appTheme == "Dark" ? Colors.grey.shade800 : Colors.blueAccent,
          ),
          child: Text(translations[uiLanguage]!["send"]!),
        ),
      ],
    );
  }

  Widget _buildSingleField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: _buildInputDecoration(label),
      maxLines: null,
    );
  }

  Widget _buildOutputContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(5),
        color: fieldFillColor,
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  Widget _buildFieldContainer(Widget child, {required double width}) {
    return Center(
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = translations[uiLanguage]!;
    final double fieldWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      body: Container(
        decoration: appTheme == "Dark"
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF010A13),
                    Color(0xFF021B2E),
                    Color(0xFF041F3F),
                  ],
                ),
              )
            : BoxDecoration(color: backgroundColor),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 140,
              color: Colors.transparent,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 38,
                          tooltip: "Sair",
                          icon: Image.asset(
                            'assets/signout.png',
                            width: 38,
                            height: 38,
                            color: textColor,
                          ),
                          onPressed: () async {
                            await StorageService.clearToken();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          },
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          key: _settingsKey,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 24,
                          tooltip: "Settings",
                          icon: Image.asset(
                            'assets/settings.png',
                            width: 24,
                            height: 24,
                            color: textColor,
                          ),
                          onPressed: () {
                            final RenderBox renderBox =
                                _settingsKey.currentContext!.findRenderObject()
                                    as RenderBox;
                            final Offset offset = renderBox.localToGlobal(Offset.zero);
                            final Size size = renderBox.size;

                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                  offset.dx, offset.dy + size.height, offset.dx + 1, 0),
                              items: [
                                PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/user.png', width: 18, height: 18),
                                        const SizedBox(width: 10),
                                        Text(t["profile"]!), 
                                      ],
                                    ),
                                    onTap: () {
                                      Future.delayed(Duration.zero, (){
                                        Navigator.push(context, 
                                        MaterialPageRoute(builder: 
                                        (context)=> ProfileScreen(
                                          appTheme: appTheme, uiLanguage: uiLanguage, translations: translations
                                        ),
                                      ),
                                    );
                                      });
                                    },
                                  ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Image.asset('assets/help.png', width: 18, height: 18),
                                      const SizedBox(width: 10),
                                      Text(t["help"]!), 
                                    ],
                                  ),
                                  onTap: () {
                                    Future.delayed(Duration.zero, (){
                                      Navigator.push(context,
                                      MaterialPageRoute(builder:
                                      (context)=> HelpScreen(appTheme: appTheme, uiLanguage: uiLanguage, translations: translations
                                      ),
                                    ),
                                  );
                                    });
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Image.asset('assets/dev.png', width: 18, height: 18),
                                      const SizedBox(width: 10),
                                      Text(t["developer"]!),
                                    ],
                                  ),
                                  onTap: () {
                                    Future.delayed(Duration.zero, (){
                                      Navigator.push(context,
                                      MaterialPageRoute(builder:
                                      (context)=> DevScreen(appTheme: appTheme, uiLanguage: uiLanguage, translations: translations
                                      ),
                                    ),
                                  );
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
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
                              position:
                                  const RelativeRect.fromLTRB(1000, 80, 16, 0),
                              items: [
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => appTheme = "White"),
                                    child: const Text("White")),
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => appTheme = "Dark"),
                                    child: const Text("Dark")),
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => appTheme = "Light"),
                                    child: const Text("Light")),
                              ],
                            );
                          },
                        ),
                        IconButton(
                          tooltip: "Idioma",
                          icon: Image.asset(
                            'assets/translate.png',
                            width: 38,
                            height: 38,
                            color: textColor,
                          ),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(1000, 80, 16, 0),
                              items: [
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => uiLanguage = "pt"),
                                    child: const Text("Português")),
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => uiLanguage = "en"),
                                    child: const Text("English")),
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => uiLanguage = "es"),
                                    child: const Text("Español")),
                                PopupMenuItem(
                                    onTap: () =>
                                        setState(() => uiLanguage = "fr"),
                                    child: const Text("Français")),
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


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    _buildFieldContainer(
                      _buildFieldWithButton(
                          textController, t["summarize"]!, () async {
                        final result =
                            await ApiService.summarize(textController.text);
                        setState(() => summary = result["summary"] ?? "");
                      }),
                      width: fieldWidth,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldContainer(
                        _buildOutputContainer("${t["summary"]}: $summary"),
                        width: fieldWidth),
                    const SizedBox(height: 24),
                    _buildFieldContainer(
                        _buildSingleField(contextController, t["context"]!),
                        width: fieldWidth),
                    const SizedBox(height: 16),
                    _buildFieldContainer(
                      Row(
                        children: [
                          Expanded(
                              child: _buildSingleField(
                                  questionController, t["question"]!)),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () async {
                              final result = await ApiService.answer(
                                  contextController.text,
                                  questionController.text);
                              setState(() => answer = result["answer"] ?? "");
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: textColor,
                              backgroundColor: appTheme == "Dark"
                                  ? Colors.grey.shade800
                                  : Colors.blueAccent,
                            ),
                            child: Text(translations[uiLanguage]!["send"]!),
                          ),
                        ],
                      ),
                      width: fieldWidth,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldContainer(
                        _buildOutputContainer("${t["answer"]}: $answer"),
                        width: fieldWidth),
                    const SizedBox(height: 24),
                    _buildFieldContainer(
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: _buildSingleField(
                                      translateController, t["translate"]!)),
                              const SizedBox(width: 16),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.08,
                                child: DropdownButton<String>(
                                  value: language,
                                  isExpanded: true,
                                  alignment: AlignmentDirectional.centerStart,
                                  dropdownColor: backgroundColor,
                                  style: TextStyle(color: textColor),
                                  items: languagesList.map((lang) {
                                    return DropdownMenuItem(
                                      value: lang["code"],
                                      child: Text(
                                        languageNames[uiLanguage]![
                                            lang["code"]]!,
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => language = value!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await ApiService.translate(
                                    translateController.text, language);
                                setState(
                                    () => translated = result["translated"] ?? "");
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: textColor,
                                backgroundColor: appTheme == "Dark"
                                    ? Colors.grey.shade800
                                    : Colors.blueAccent,
                              ),
                              child: Text(translations[uiLanguage]!["send"]!),
                            ),
                          ),
                        ],
                      ),
                      width: fieldWidth,
                    ),
                    const SizedBox(height: 16),
                    _buildFieldContainer(
                        _buildOutputContainer("${t["translated"]}: $translated"),
                        width: fieldWidth),
                    const SizedBox(height: 40),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final token = await StorageService.getSavedToken();
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
                                SnackBar(
                                    content:
                                        Text(result["message"] ?? "Erro ao salvar")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: textColor,
                              backgroundColor: appTheme == "Dark"
                                  ? Colors.grey.shade800
                                  : Colors.cyanAccent.withOpacity(0.1),
                              side: BorderSide(color: textColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            child: Text(
                              t["sendAll"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                textController.clear();
                                contextController.clear();
                                questionController.clear();
                                translateController.clear();
                                language = "pt-BR";
                                summary = "";
                                answer = "";
                                translated = "";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: textColor,
                              backgroundColor: appTheme == "Dark"
                                  ? Colors.grey.shade800
                                  : Colors.cyanAccent.withOpacity(0.1),
                              side: BorderSide(color: textColor),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            child: Text(
                              t["clean"]!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, letterSpacing: 1.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: appTheme == "Dark" ? Colors.black54 : Colors.blue.shade50,
              child: Center(
                child: Text(
                  "🏠 HomeScreen  👤 User: $loggedUser     🔌 API: ${apiOnline ? "Online" : "Offline"}     ⚙️ Backend: v1.0.0",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
