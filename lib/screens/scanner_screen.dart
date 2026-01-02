import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _api = ApiService();
  final TextEditingController _quantityController = TextEditingController();
  bool isScanning = true;

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;

    final barcode = capture.barcodes.first;
    if (barcode.rawValue != null) {
      setState(() => isScanning = false); // Pausar scanner
      _showStockDialog(barcode.rawValue!);
    }
  }

  void _showStockDialog(String sku) {
    _quantityController.text = "1"; // Valor por defecto

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("SKU Detectado: $sku", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ingrese la cantidad personalizada:"),
            SizedBox(height: 15),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ejemplo: 5",
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        actions: [
          // Botón para Ingreso de Stock (Suma)
          ElevatedButton.icon(
            onPressed: () => _handleAction(sku, isSale: false),
            icon: Icon(Icons.add_circle, color: Colors.white),
            label: Text("INGRESO"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
          // Botón para Venta (Resta)
          ElevatedButton.icon(
            onPressed: () => _handleAction(sku, isSale: true),
            icon: Icon(Icons.remove_circle, color: Colors.white),
            label: Text("VENTA"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanning = true);
            },
            child: Text("CANCELAR", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _handleAction(String sku, {required bool isSale}) {
    int qty = int.tryParse(_quantityController.text) ?? 0;

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Por favor ingrese una cantidad válida mayor a 0"))
      );
      return;
    }

    // Si es venta, convertimos la cantidad a negativo para la API
    int finalQty = isSale ? -qty : qty;
    _process(sku, finalQty);
  }

  void _process(String sku, int qty) async {
    // Se utiliza el método updateStock definido en tu ApiService
    final result = await _api.updateStock(sku, qty);

    if (mounted) {
      Navigator.pop(context); // Cerrar diálogo

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Operación exitosa"),
            backgroundColor: qty > 0 ? Colors.green : Colors.orange,
          )
      );

      setState(() => isScanning = true); // Reiniciar scanner
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestión de Inventario")),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}