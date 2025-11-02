import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'storage_service.dart';
import 'main.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'help_screen.dart';

class DevScreen extends StatefulWidget {
  final String appTheme;
  final String uiLanguage;
  final Map<String, Map<String, String>> translations;

  const DevScreen({
    super.key,
    required this.appTheme,
    required this.uiLanguage,
    required this.translations,
  });

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  final GlobalKey _settingsKey = GlobalKey();
  late String appTheme;
  late String uiLanguage;
  late Map<String, String> t;

  bool isHoveringLinkedIn = false;
  bool isHoveringGmail = false;

  @override
  void initState() {
    super.initState();
    appTheme = widget.appTheme;
    uiLanguage = widget.uiLanguage;
    t = widget.translations[uiLanguage]!;
  }

  void _changeLanguage(String lang) {
    setState(() {
      uiLanguage = lang;
      t = widget.translations[uiLanguage]!;
    });
  }

  void _showLanguageMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      items: [
        PopupMenuItem(
          child: const Text("Português"),
          onTap: () => Future.delayed(Duration.zero, () => _changeLanguage("pt")),
        ),
        PopupMenuItem(
          child: const Text("English"),
          onTap: () => Future.delayed(Duration.zero, () => _changeLanguage("en")),
        ),
        PopupMenuItem(
          child: const Text("Español"),
          onTap: () => Future.delayed(Duration.zero, () => _changeLanguage("es")),
        ),
        PopupMenuItem(
          child: const Text("Français"),
          onTap: () => Future.delayed(Duration.zero, () => _changeLanguage("fr")),
        ),
      ],
    );
  }

  Color get textColor => appTheme == "Dark" ? Colors.cyanAccent : Colors.black87;

  Color get backgroundColor {
    switch (appTheme) {
      case "Dark":
        return Colors.transparent;
      case "Light":
        return Colors.purple.shade50;
      default:
        return Colors.white;
    }
  }

  Future<void> _launchLinkedIn() async {
    final Uri url = Uri.parse('https://www.linkedin.com/in/lucas-martins-43aa5419b/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir o LinkedIn.');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'lucasalvesmartins@gmail.com',
      query: Uri.encodeFull('subject=Suporte - MAKENLP'),
    );
    if (!await launchUrl(emailUri)) {
      throw Exception('Não foi possível abrir o aplicativo de e-mail.');
    }
  }

  final Map<String, String> devTextsPt = {
    "dev_text": '''
👨‍💻 Desenvolvedor:
O Desenvolvedor do MAKENLP se chama Lucas Alves Martins, nascido em 17/09/1999.  
Formado em Engenharia da Computação, atua como Analista de Sistemas, Desenvolvedor de Software e Engenheiro de Inteligência Artificial.

              🌐 Redes Sociais e Contato de Suporte
'''
  };

  final Map<String, String> devTextsEn = {
    "dev_text": '''
👨‍💻 Developer:
The Developer of MAKENLP is Lucas Alves Martins, born on September 17, 1999.  
Graduated in Computer Engineering, he works as a Systems Analyst, Software Developer, and Artificial Intelligence Engineer.

              🌐 Social Media & Support Contact
'''
  };

  final Map<String, String> devTextsEs = {
    "dev_text": '''
👨‍💻 Desarrollador:
El Desarrollador de MAKENLP es Lucas Alves Martins, nacido el 17/09/1999.  
Graduado en Ingeniería Informática, trabaja como Analista de Sistemas, Desarrollador de Software e Ingeniero de Inteligencia Artificial.

              🌐 Redes Sociales y Contacto de Soporte
'''
  };

  final Map<String, String> devTextsFr = {
    "dev_text": '''
👨‍💻 Développeur :
Le Développeur de MAKENLP est Lucas Alves Martins, né le 17/09/1999.  
Diplômé en Génie Informatique, il travaille comme Analyste Systèmes, Développeur Logiciel et Ingénieur en Intelligence Artificielle.

              🌐 Réseaux Sociaux et Contacter l'assistance
'''
  };

  @override
  Widget build(BuildContext context) {
    final devText = uiLanguage == "pt"
        ? devTextsPt["dev_text"]
        : uiLanguage == "en"
            ? devTextsEn["dev_text"]
            : uiLanguage == "es"
                ? devTextsEs["dev_text"]
                : devTextsFr["dev_text"];

    return Scaffold(
      backgroundColor: backgroundColor,
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
                                      print("Perfil");
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
                                      (context)=> HelpScreen(appTheme: appTheme, uiLanguage: uiLanguage, translations: widget.translations
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
                                      (context)=> DevScreen(appTheme: appTheme, uiLanguage: uiLanguage, translations: widget.translations
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
                          onPressed: _showLanguageMenu,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Image.asset('assets/dev.jpg', width: 240, height: 240),
            const SizedBox(height: 10),
            Text(
              t["developer"] ?? "Desenvolvedor",
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      devText!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor, fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 25),

                    // Ícones e textos invertidos (texto à esquerda, ícone à direita)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MouseRegion(
                          onEnter: (_) => setState(() => isHoveringLinkedIn = true),
                          onExit: (_) => setState(() => isHoveringLinkedIn = false),
                          child: GestureDetector(
                            onTap: _launchLinkedIn,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isHoveringLinkedIn
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    uiLanguage == "pt"
                                        ? "Rede Social"
                                        : uiLanguage == "en"
                                            ? "Social Media"
                                            : uiLanguage == "es"
                                                ? "Red Social"
                                                : "Réseau Social",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset('assets/linkedin.png', width: 36, height: 36),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                        MouseRegion(
                          onEnter: (_) => setState(() => isHoveringGmail = true),
                          onExit: (_) => setState(() => isHoveringGmail = false),
                          child: GestureDetector(
                            onTap: _launchEmail,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isHoveringGmail
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    uiLanguage == "pt"
                                        ? "Contato de Suporte"
                                        : uiLanguage == "en"
                                            ? "Support Contact"
                                            : uiLanguage == "es"
                                                ? "Contacto de Soporte"
                                                : "Contact Assistance",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset('assets/gmail.png', width: 36, height: 36),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  t["home"] ?? "Voltar à Home",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
