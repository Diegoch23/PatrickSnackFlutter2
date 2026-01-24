import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'app_language';

  /// Idiomas soportados con sus códigos y nombres nativos
  static const Map<String, Map<String, String>> supportedLanguages = {
    'es': {'name': 'Español', 'flag': '🇪🇸'},
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'fr': {'name': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'zh': {'name': '中文', 'flag': '🇨🇳'},
  };

  /// Guardar el idioma seleccionado
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Obtener el idioma guardado (por defecto: español)
  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'es';
  }

  /// Verificar si ya se seleccionó un idioma
  static Future<bool> hasLanguageSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_languageKey);
  }

  /// Convertir código de idioma a Locale
  static Locale getLocaleFromCode(String languageCode) {
    return Locale(languageCode);
  }

  /// Obtener lista de Locales soportados
  static List<Locale> getSupportedLocales() {
    return supportedLanguages.keys.map((code) => Locale(code)).toList();
  }
}