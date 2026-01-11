import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Hive y abrir las cajas necesarias
  await Hive.initFlutter();
  await Hive.openBox('pending_sync');
  await Hive.openBox('products_cache');

  // 2. Verificar si hay un token guardado (Sesión activa)
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  // 3. Si hay token, la pantalla inicial es HomeScreen, si no, LoginScreen
  runApp(PatricksApp(initialScreen: token != null ? HomeScreen() : LoginScreen()));
}

class PatricksApp extends StatelessWidget {
  final Widget initialScreen;

  PatricksApp({required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Patrik's Snack Stock",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: initialScreen,
    );
  }
}