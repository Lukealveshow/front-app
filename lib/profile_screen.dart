import 'package:flutter/material.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'main.dart';
import 'home_screen.dart';
import 'reset_password.dart';

class ProfileScreen extends StatefulWidget {
  final String appTheme;
  final String uiLanguage;
  final Map<String, Map<String, String>> translations;

  const ProfileScreen({
    super.key,
    required this.appTheme,
    required this.uiLanguage,
    required this.translations,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _settingsKey = GlobalKey();
  late String appTheme;
  late String uiLanguage;
  late Map<String, String> t;

  bool _obscurePassword = true;
  String _realPassword = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey _languageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    appTheme = widget.appTheme;
    uiLanguage = widget.uiLanguage;
    t = widget.translations[uiLanguage]!;

    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    try {
      final token = await StorageService.getSavedToken();
      if (token.isEmpty) return;

      final response = await ApiService.getUserData(token);
      if (response["status"] == "success") {
        final user = response["user"];
        setState(() {
          _nameController.text = user["login"] ?? "";
          _emailController.text = user["email"] ?? "";
          _realPassword = user["password"] ?? "";
          _passwordController.text = "********";
        });
      } else {
        debugPrint("Erro ao buscar usuário: ${response["message"]}");
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados do usuário: $e");
    }
  }

  Color get textColor =>
      appTheme == "Dark" ? Colors.cyanAccent : Colors.black87;

  Color get fieldFillColor =>
      appTheme == "Dark" ? Colors.black.withOpacity(0.25) : Colors.white;

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

  InputDecoration _buildInputDecoration(String label, {Widget? suffixIcon}) {
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
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fieldFillColor,
    );
  }

  void _changeLanguage(String lang) {
  setState(() {
    uiLanguage = lang;
    t = widget.translations[lang] ?? {}; 
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


  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.35;

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

            const SizedBox(height: 30),
            Image.asset('assets/user.png', width: 160, height: 160, color: textColor),
            const SizedBox(height: 10),
            Text(
              t["profile"] ?? "Perfil",
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Nome
                      SizedBox(
                        width: fieldWidth,
                        child: TextField(
                          controller: _nameController,
                          readOnly: true,
                          style: TextStyle(color: textColor),
                          decoration: _buildInputDecoration(t["login"] ?? "Login"),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // E-mail
                      SizedBox(
                        width: fieldWidth,
                        child: TextField(
                          controller: _emailController,
                          readOnly: true,
                          style: TextStyle(color: textColor),
                          decoration: _buildInputDecoration(t["email"] ?? "E-mail"),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Senha
                      SizedBox(
                        width: fieldWidth,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          readOnly: true,
                          style: TextStyle(color: textColor),
                          decoration: _buildInputDecoration(
                            t["password"] ?? "Senha",
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: textColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                      _passwordController.text = _obscurePassword
                                          ? "********"
                                          : _realPassword;
                                    });
                                  },
                                ),
                                IconButton(
                                  tooltip: t["reset_password"] ?? "Redefinir Senha",
                                  icon: const Icon(Icons.refresh, color: Colors.black),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPasswordScreen(login: _nameController.text),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Voltar à Home
                      ElevatedButton(
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
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
