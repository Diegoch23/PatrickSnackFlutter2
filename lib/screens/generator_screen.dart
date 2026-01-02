import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import '../services/api_service.dart';

class GeneratorScreen extends StatefulWidget {
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _api = ApiService();
  final _screenshotController = ScreenshotController();
  List<dynamic> products = [];
  String? selectedSku;
  String? selectedName;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  _loadProducts() async {
    final data = await _api.getProducts(); // Debes implementar getProducts() en ApiService que llame a /api/stock
    setState(() => products = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generador de Códigos")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              isExpanded: true,
              hint: Text("Seleccione un producto"),
              value: selectedSku,
              // Especificamos <String> aquí para que coincida con el DropdownButton
              items: products.map<DropdownMenuItem<String>>((p) {
                return DropdownMenuItem<String>(
                  value: p['sku'].toString(), // Forzamos a que sea String
                  child: Text("${p['sku']} - ${p['name']}"),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedSku = val;
                  selectedName = products.firstWhere((p) => p['sku'] == val)['name'];
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
                      Text(selectedName!, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final image = await _screenshotController.capture();
                  if (image != null) {
                    await Gal.putImageBytes(image);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Imagen guardada en galería")));
                  }
                },
                icon: Icon(Icons.download),
                label: Text("Guardar en Teléfono"),
              )
            ]
          ],
        ),
      ),
    );
  }
}