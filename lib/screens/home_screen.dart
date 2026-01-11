import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importante para ValueListenableBuilder
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'generator_screen.dart';
import 'scanner_screen.dart';
import 'stock_view_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    // 1. Escuchar cambios de conexión en tiempo real
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // Si recupera internet, intenta subir lo pendiente automáticamente
        _api.syncPendingData();
      }
    });

    // 2. Intentar sincronizar al abrir la pantalla por primera vez
    _api.syncPendingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Patrik's Snack"),
        centerTitle: true,
        actions: [
          // INDICADOR DE SINCRONIZACIÓN (NUEVO)
          ValueListenableBuilder(
            valueListenable: Hive.box('pending_sync').listenable(),
            builder: (context, Box box, widget) {
              if (box.isEmpty) return SizedBox.shrink();
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.cloud_upload, color: Colors.blue),
                    onPressed: () => _api.syncPendingData(),
                    tooltip: "Sincronizar ahora",
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        box.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
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

              // AVISO VISUAL SI HAY DATOS PENDIENTES
              ValueListenableBuilder(
                valueListenable: Hive.box('pending_sync').listenable(),
                builder: (context, Box box, widget) {
                  if (box.isEmpty) return SizedBox.shrink();
                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[800]),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Tienes ${box.length} registros sin subir. Se sincronizarán cuando tengas internet.",
                            style: TextStyle(color: Colors.orange[900], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- LAS FUNCIONES _showLogoutDialog y _menuButton SE MANTIENEN IGUAL QUE ANTES ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cerrar Sesión"),
        content: Text("¿Estás seguro de que deseas salir de Patrik's Snack?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCELAR")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LoginScreen()),
                    (route) => false,
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