import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Hive y abrir las cajas necesarias
  await Hive.initFlutter();
  await Hive.openBox('pending_sync');
  await Hive.openBox('products_cache');

  // 2. Verificar si hay un token guardado (Sesión activa)
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // 3. Obtener idioma guardado (si existe, sino español por defecto)
  final String savedLanguage = await LanguageService.getSavedLanguage();

  // 4. SIEMPRE mostrar selector de idioma si no hay sesión activa
  Widget initialScreen;
  if (token != null) {
    // Si hay token, ir directamente a Home
    initialScreen = HomeScreen();
  } else {
    // Si NO hay token, SIEMPRE mostrar selector de idioma
    initialScreen = LanguageSelectionScreen();
  }

  runApp(PatricksApp(
    initialScreen: initialScreen,
    initialLocale: LanguageService.getLocaleFromCode(savedLanguage),
  ));
}

class PatricksApp extends StatefulWidget {
  final Widget initialScreen;
  final Locale initialLocale;

  PatricksApp({required this.initialScreen, required this.initialLocale});

  @override
  _PatricksAppState createState() => _PatricksAppState();

  // método estático para cambiar el idioma desde cualquier parte de la app
  static void setLocale(BuildContext context, Locale newLocale) {
    _PatricksAppState? state = context.findAncestorStateOfType<_PatricksAppState>();
    state?.setLocale(newLocale);
  }
}

class _PatricksAppState extends State<PatricksApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Patrik's Snack Stock",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),

      // Configuración de localización
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageService.getSupportedLocales(),

      home: widget.initialScreen,
    );
  }
}