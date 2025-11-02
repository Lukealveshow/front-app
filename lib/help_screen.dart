import 'package:flutter/material.dart';
import 'storage_service.dart';
import 'main.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HelpScreen extends StatefulWidget {
  final String appTheme;
  final String uiLanguage;
  final Map<String, Map<String, String>> translations;

  const HelpScreen({
    super.key,
    required this.appTheme,
    required this.uiLanguage,
    required this.translations,
  });

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final GlobalKey _settingsKey = GlobalKey();
  late String appTheme;
  late String uiLanguage;
  late Map<String, String> t;

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

  Color get textColor =>
      appTheme == "Dark" ? Colors.cyanAccent : Colors.black87;

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

  final Map<String, String> helpTextsPt = {
    "help_text": '''
O MAKENLP é um software de Inteligência Artificial criado para facilitar o uso de recursos de linguagem natural.

💡 **Como usar:**
1. Na tela principal, você pode:
   • Resumir textos (campo “Texto para Sumarização”);
   • Fazer perguntas com base em um contexto (campo “Texto para gerar Resposta”);
   • Opção para escolher o idioma de destino da tradução, permitindo definir para qual idioma o texto será traduzido;
   • Traduzir textos para outros idiomas (campo “Tradução Textual”).

2. O sistema usa tecnologia de IA para processar seu texto e gerar respostas rápidas e precisas.

3. Todos os seus dados são associados à sua conta e podem ser salvos automaticamente.

🔐 **Segurança da conta:**
- É necessário se cadastrar e confirmar o e-mail para usar.
- Se esquecer sua senha, use “Esqueci minha senha” na tela de login.
- Você pode redefinir sua senha quando quiser na tela de perfil.

⚙️ **Personalização:**
🌍 Altere o idioma e o tema da interface usando os ícones no topo das telas.

🧠 O MAKENLP foi feito para ajudar estudantes, pesquisadores e profissionais e usuários de todos os tipos,
   a economizar tempo terem mais facilidade para trabalharem com textos e aprimorar o uso da Inteligência Artificial.
'''
  };

  final Map<String, String> helpTextsEn = {
    "help_text": '''
MAKENLP is an Artificial Intelligence software designed to make natural language tools easy to use.

💡 **How to use:**
1. On the main screen, you can:
   • Summarize texts ("Text for Summarization");
   • Ask questions based on a context ("Text for Answer Generation");
   • Option to select the target translation language, letting you choose which language the text will be translated into.;
   • Translate text into other languages ("Text Translation").

2. The system uses AI technology to process your text and provide quick, accurate results.

3. All your data is linked to your account and can be saved automatically.

🔐 **Account security:**
- You need to register and confirm your email to use the system.
- If you forget your password, click “Forgot Password” on the login screen.
- You can reset your password anytime on the profile screen.

⚙️ **Customization:**
🌍 Change the interface language and theme using the icons at the top of the screens.

🧠 MAKENLP was created to help students, researchers, professionals, and users of all kinds,
 save time, work more easily with texts, and enhance their use of Artificial Intelligence.
'''
  };

  final Map<String, String> helpTextsEs = {
    "help_text": '''
MAKENLP es un software de Inteligencia Artificial creado para facilitar el uso de herramientas de lenguaje natural.

💡 **Cómo usar:**
1. En la pantalla principal puedes:
   • Resumir textos (“Texto para Resumir”);
   • Hacer preguntas basadas en un contexto (“Texto para generar Respuesta”);
   • Opción para elegir el idioma de destino de la traducción, indicando a qué idioma se traducirá el texto.;
   • Traducir textos a otros idiomas (“Traducción de Texto”).

2. El sistema utiliza tecnología de IA para procesar tu texto y generar respuestas rápidas y precisas.

3. Todos tus datos están asociados a tu cuenta y pueden guardarse automáticamente.

🔐 **Seguridad de la cuenta:**
- Es necesario registrarse y confirmar tu correo electrónico.
- Si olvidas tu contraseña, usa “Olvidé mi contraseña” en la pantalla de inicio de sesión.
- Puedes restablecer tu contraseña en cualquier momento desde el perfil.

⚙️ **Personalización:**
🌍 Cambia el idioma y el tema de la interfaz usando los íconos en la parte superior de las pantallas.

🧠 MAKENLP fue creado para ayudar a estudiantes, investigadores, profesionales y usuarios de todo tipo,
 a ahorrar tiempo, trabajar con mayor facilidad con textos y mejorar el uso de la Inteligencia Artificial.
'''
  };

  final Map<String, String> helpTextsFr = {
    "help_text": '''
MAKENLP est un logiciel d’Intelligence Artificielle conçu pour simplifier l’utilisation des outils de langage naturel.

💡 **Comment utiliser :**
1. Sur l’écran principal, vous pouvez :
   • Résumer de textes (“Texte à Résumer”) ;
   • Poser des questions à partir d’un contexte (“Texte pour Générer une Réponse”);
   • Option pour choisir la langue cible de la traduction, afin de définir vers quelle langue le texte sera traduit.;
   • Traduire du texte dans d’autres langues (“Traduction de Texte”).

2. Le système utilise l’IA pour traiter vos textes et générer des réponses rapides et précises.

3. Toutes vos données sont liées à votre compte et peuvent être sauvegardées automatiquement.

🔐 **Sécurité du compte :**
- Vous devez vous inscrire et confirmer votre e-mail pour utiliser le système.
- Si vous oubliez votre mot de passe, utilisez “Mot de passe oublié” sur l’écran de connexion.
- Vous pouvez réinitialiser votre mot de passe à tout moment sur l’écran de profil.

⚙️ **Personnalisation :**
🌍 Changez la langue et le thème de l’interface grâce aux icônes situées en haut des écrans.

🧠 MAKENLP a été conçu pour aider les étudiants, les chercheurs, les professionnels et les utilisateurs de tous types,
 à gagner du temps, à travailler plus facilement avec les textes et à améliorer leur utilisation de l’intelligence artificielle.
'''
  };

  @override
  Widget build(BuildContext context) {
    final helpText = uiLanguage == "pt"
        ? helpTextsPt["help_text"]
        : uiLanguage == "en"
            ? helpTextsEn["help_text"]
            : uiLanguage == "es"
                ? helpTextsEs["help_text"]
                : helpTextsFr["help_text"];

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
            // TOPO
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
                                          appTheme: appTheme, uiLanguage: uiLanguage, translations: widget.translations
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
                                    print("Ajuda");
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
                                    print("Desenvolvedor");
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

            const SizedBox(height: 20),
            Image.asset('assets/help.png', width: 150, height: 150, color: textColor),
            const SizedBox(height: 10),
            Text(
              t["help"] ?? "Ajuda",
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  helpText!,
                  style: TextStyle(color: textColor, fontSize: 16, height: 1.6),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
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
