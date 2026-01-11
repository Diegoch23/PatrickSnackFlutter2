import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Añadir Hive
import '../services/api_service.dart';

class GeneratorScreen extends StatefulWidget {
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _api = ApiService();
  final _screenshotController = ScreenshotController();
  final Box _productsBox = Hive.box('products_cache'); // Usar la caché del inventario

  List<dynamic> products = [];
  String? selectedSku;
  String? selectedName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    setState(() => isLoading = true);

    // 1. Intentar cargar de la API
    try {
      final data = await _api.getProducts();
      if (data.isNotEmpty) {
        await _productsBox.put('list', data); // Actualizar caché
        setState(() {
          products = data;
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      print("Error cargando productos en generador: $e");
    }

    // 2. Si falla o no hay internet, usar caché local
    final cachedData = _productsBox.get('list');
    if (cachedData != null) {
      setState(() {
        products = List<dynamic>.from(cachedData);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generador de Códigos")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (products.isEmpty)
              Text("No hay productos disponibles. Conéctese a internet para sincronizar.")
            else
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Seleccione un producto"),
                value: selectedSku,
                items: products.map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem<String>(
                    value: p['sku'].toString(),
                    child: Text("${p['sku']} - ${p['name']}"),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedSku = val;
                    selectedName = products.firstWhere((p) => p['sku'].toString() == val)['name'];
                  });
                },
              ),

            if (selectedSku != null) ...[
              SizedBox(height: 40),
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: selectedSku!,
                        width: 300,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Text(selectedName!, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveBarcode,
                icon: Icon(Icons.download),
                label: Text("Guardar en Teléfono"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              )
            ]
          ],
        ),
      ),
    );
  }

  // Extraer la lógica de guardado para que sea más limpia
  Future<void> _saveBarcode() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        await Gal.putImageBytes(image);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Código de barras guardado en la galería"))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la imagen"), backgroundColor: Colors.red)
      );
    }
  }
}