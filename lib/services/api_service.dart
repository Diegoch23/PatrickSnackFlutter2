import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // IP para emulador Android: 10.0.2.2. Para teléfono real: usa tu IP local (ej. 192.168.1.50)
  final String baseUrl = "http://192.168.101.4:8000/api";

  // Guardar el token de forma segura en el móvil
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Petición de Login
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return true;
    }
    return false;
  }

  // Petición para Modificar Stock por SKU
  Future<Map<String, dynamic>> updateStock(String sku, int quantity) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/stock/update-sku'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'sku': sku, 'quantity': quantity}),
    );
    return jsonDecode(response.body);
  }
  // Obtener lista de productos (GET)
  Future<List<dynamic>> getProducts() async {
    final token = await getToken();
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
  }
}