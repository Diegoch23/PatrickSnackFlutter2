import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final String baseUrl = "https://patricksnack.espe-projects.com/api";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<Map<String, dynamic>> updateStock(String sku, int quantity) async {
    final token = await getToken();
    var connectivityResult = await (Connectivity().checkConnectivity());

    // 1. Verificación de conexión inmediata
    if (connectivityResult == ConnectivityResult.none) {
      return await _saveToOfflineCache(sku, quantity, "Sin conexión. Guardado localmente.");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stock/update-sku'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'sku': sku, 'quantity': quantity}),
      ).timeout(const Duration(seconds: 8)); // Un poco más de tiempo por si el hostinger es lento

      return jsonDecode(response.body);
    } catch (e) {
      // 2. Si falla la petición (timeout o error de servidor), guardar en caché
      return await _saveToOfflineCache(sku, quantity, "Error de red. Guardado en caché.");
    }
  }

  // Metodo auxiliar para evitar repetir código de guardado local
  Future<Map<String, dynamic>> _saveToOfflineCache(String sku, int qty, String msg) async {
    final box = Hive.box('pending_sync');
    await box.add({
      'sku': sku,
      'quantity': qty,
      'timestamp': DateTime.now().toIso8601String(),
    });
    return {'message': msg};
  }

  Future<void> syncPendingData() async {
    final box = Hive.box('pending_sync');
    if (box.isEmpty) return;

    final token = await getToken();
    if (token == null) return; // No sincronizar si no hay sesión

    List<dynamic> keysToDelete = [];

    print("Sincronizando ${box.length} registros pendientes...");

    for (var key in box.keys) {
      final item = box.get(key);
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/stock/update-sku'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'sku': item['sku'], 'quantity': item['quantity']}),
        );

        if (response.statusCode == 200) {
          keysToDelete.add(key);
        }
      } catch (e) {
        print("Fallo intento de sincro para key $key: $e");
        break; // Si falla uno por red, probablemente los demás también fallarán
      }
    }

    // ELIMINACIÓN FUERA DEL CICLO PRINCIPAL
    for (var key in keysToDelete) {
      await box.delete(key);
    }

    if (keysToDelete.isNotEmpty) {
      print("Sincronización completada: ${keysToDelete.length} items subidos.");
    }
  }

  // Obtener lista de productos (GET) - Opcional: también podrías cachear esto
  Future<List<dynamic>> getProducts() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stock'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      // Si falla el stock y estás offline, podrías retornar una lista vacía
      // o cargar una caché previa si decides implementarla.
      return [];
    }
  }
}