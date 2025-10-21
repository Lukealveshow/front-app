import 'package:flutter/material.dart';

class LanguageService {
  static final ValueNotifier<String> currentLanguage = ValueNotifier<String>("pt");

  static final Map<String, Map<String, String>> translations = {
    "pt": {
      "login": "login",
      "email": "E-mail",
      "email_verification": "Verificação de E-mail",
      "password": "Senha",
      "new_password": "Nova Senha",
      "confirm_password": "Confirmar Senha",
      "forgot_password": "Esqueci minha senha",
      "reset_password": "Redefinir Senha",
      "send_code": "Enviar código de verificação",
      "enter_code_sent_to": "Entre com o código enviado para",
      "register": "Registrar",
      "create_account": "Criar Conta",
      "verify_email": "Verificação de E-mail",
      "enter_verification_code": "Entre com o código de verificação",
      "verification_code": "Código de verificação",
      "back": "Voltar",
      "back_to_login": "Voltar para Login",
      "welcome": "Bem-vindo ao MAKENLP",
    },
    "en": {
      "login": "login",
      "email": "Email",
      "email_verification": "Email Verification",
      "password": "Password",
      "new_password": "New Password",
      "confirm_password": "Confirm Password",
      "forgot_password": "Forgot Password",
      "reset_password": "Reset Password",
      "send_code": "Send verification code",
      "enter_code_sent_to": "Enter with the code sent to",
      "register": "Register",
      "create_account": "Create Account",
      "verify_email": "Email Verification",
      "enter_verification_code": "Enter with the verification code",
      "verification_code": "Verification Code",
      "back": "Back",
      "back_to_login": "Back to Login",
      "welcome": "Welcome to MAKENLP",
    },
  };

  static String t(String key) {
    return translations[currentLanguage.value]?[key] ?? key;
  }
}
