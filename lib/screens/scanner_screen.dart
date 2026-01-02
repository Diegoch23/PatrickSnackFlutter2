import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _api = ApiService();
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Producto: $sku"),
        content: Text("¿Qué desea hacer con el stock?"),
        actions: [
          TextButton(onPressed: () => _process(sku, 1), child: Text("SUMAR 1")),
          TextButton(onPressed: () => _process(sku, -1), child: Text("RESTAR 1")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanning = true);
            },
            child: Text("CANCELAR"),
          ),
        ],
      ),
    );
  }

  void _process(String sku, int qty) async {
    final result = await _api.updateStock(sku, qty);
    Navigator.pop(context); // Cerrar diálogo

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Stock actualizado"))
    );

    setState(() => isScanning = true); // Reiniciar scanner
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner de Stock")),
      body: MobileScanner(
        onDetect: _onDetect,
      ),
    );
  }
}