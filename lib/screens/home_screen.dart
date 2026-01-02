import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importante para borrar el token
import 'login_screen.dart';
import 'generator_screen.dart';
import 'scanner_screen.dart';
import 'stock_view_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Patrik's Snack"),
        centerTitle: true,
        // Añadimos el botón de cerrar sesión en la parte derecha
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Cerrar Sesión",
            onPressed: () => _showLogoutDialog(context),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              _menuButton(context, "Generar Código de Barras", Icons.qr_code, Colors.blue, GeneratorScreen()),
              SizedBox(height: 20),
              _menuButton(context, "Escanear Producto", Icons.camera_alt, Colors.orange, ScannerScreen()),
              SizedBox(height: 20),
              _menuButton(context, "Visualizar Stock", Icons.inventory, Colors.green, StockViewScreen()),
            ],
          ),
        ),
      ),
    );
  }

  // Función para confirmar el cierre de sesión (Mejora la UX)
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cerrar Sesión"),
        content: Text("¿Estás seguro de que deseas salir de Patrik's Snack?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancela
            child: Text("CANCELAR"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // 1. Borrar el token de la memoria del teléfono
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

              // 2. Navegar al Login y borrar todo el historial de pantallas
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LoginScreen()),
                    (route) => false, // Esto evita que el usuario pueda volver atrás
              );
            },
            child: Text("SALIR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, IconData icon, Color color, Widget screen) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => screen)),
        icon: Icon(icon, size: 30, color: Colors.white),
        label: Text(text, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}