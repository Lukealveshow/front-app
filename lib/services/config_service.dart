import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig{
  final String baseUrl;

  AppConfig({required this.baseUrl});

  factory AppConfig.fromJson(Map<String, dynamic> json){
    final env = json["environment"];
    return AppConfig(baseUrl: env["baseUrl"]);
  }
}

class ConfigService {
  static AppConfig? _config;

  static Future<void> load() async{
    final jsonString = await rootBundle.loadString('assets/config/appsettings.json');
    final jsonMap = json.decode(jsonString);
    _config = AppConfig.fromJson(jsonMap);
  }

  static AppConfig get config{
    if(_config==null){
      throw Exception("Config not loaded. Call ConfigService.load() first.");
    }
    return _config!;
  }
}