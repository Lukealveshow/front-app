import 'package:flutter/material.dart';
import 'package:makenlp/api_service.dart';
import 'registry.dart';
import 'home_screen.dart';
import 'storage_service.dart';
import 'services/config_service.dart';
import 'reset_password.dart';
import 'forgot_password.dart';
import 'services/language_selector.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAKENLP',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF010A13),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String login = _loginController.text;
    String password = _passwordController.text;
    final result = await ApiService.login(login, '', password);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? LanguageService.t("error"))),
    );

    if (result['status'] == 'success') {
      await StorageService.saveToken(result['token']);
      await StorageService.saveUserLogin(result['login']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/login.png',
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 48),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: TextField(
                              controller: _loginController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: LanguageService.t("login"),
                                labelStyle:
                                    const TextStyle(color: Colors.cyanAccent),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyanAccent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyanAccent, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.25),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: TextField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: LanguageService.t("password"),
                                labelStyle:
                                    const TextStyle(color: Colors.cyanAccent),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyanAccent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.cyanAccent, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.25),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.cyanAccent.withOpacity(0.1),
                                foregroundColor: Colors.cyanAccent,
                                side:
                                    const BorderSide(color: Colors.cyanAccent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _login,
                              child: Text(
                                LanguageService.t("login"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.cyanAccent.withOpacity(0.1),
                                foregroundColor: Colors.cyanAccent,
                                side:
                                    const BorderSide(color: Colors.cyanAccent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                LanguageService.t("forgot_password"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.cyanAccent.withOpacity(0.1),
                                side:
                                    const BorderSide(color: Colors.cyanAccent),
                                foregroundColor: Colors.cyanAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistryScreen()),
                                );
                              },
                              child: Text(
                                LanguageService.t("create_account"),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 30,
                right: 30,
                child: LanguageSelector(),
              ),
            ],
          ),
          bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.cyanAccent, width: 0.3),
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "© 2025 MAKENLP - Todos os direitos reservados a Lucas Alves Martins",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 15,
            letterSpacing: 1.1,
              ),
            ),
          ),
        );
      },
    );
  }
}