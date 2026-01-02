import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StockViewScreen extends StatefulWidget {
  @override
  _StockViewScreenState createState() => _StockViewScreenState();
}

class _StockViewScreenState extends State<StockViewScreen> {
  final ApiService _api = ApiService();

  List<dynamic> allProducts = []; // Lista original de la API
  List<dynamic> filteredProducts = []; // Lista que se muestra al buscar
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  // Cargar datos desde la API de Laravel
  Future<void> _loadStock() async {
    try {
      final data = await _api.getProducts();
      setState(() {
        allProducts = data;
        filteredProducts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  }

  // Función para filtrar localmente (UX rápida)
  void _filterSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredProducts = allProducts
          .where((p) =>
      p['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
          p['sku'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventario Patrik's Snack"),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de búsqueda superior
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                labelText: "Buscar por nombre o SKU...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Lista de productos
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadStock, // Tirar hacia abajo para actualizar
              child: filteredProducts.isEmpty
                  ? Center(child: Text("No se encontraron productos"))
                  : ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final p = filteredProducts[index];
                  final stockQty = p['stock'] != null ? p['stock']['quantity'] : 0;

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fila 1: Nombre del producto
                          Text(
                            p['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                            ),
                          ),
                          SizedBox(height: 5),
                          Divider(color: Colors.orange[100]),

                          // Fila 2: Detalles distribuidos verticalmente para móvil
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Datos a la izquierda
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(Icons.tag, "SKU: ${p['sku']}"),
                                    SizedBox(height: 4),
                                    _infoRow(Icons.category, "Cat: ${p['category']['name']}"),
                                  ],
                                ),
                              ),

                              // Badge de Stock a la derecha
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: stockQty > 0 ? Colors.green[50] : Colors.red[50],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: stockQty > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "STOCK",
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "$stockQty",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: stockQty > 0 ? Colors.green[800] : Colors.red[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para las filas de información con iconos pequeños
  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}