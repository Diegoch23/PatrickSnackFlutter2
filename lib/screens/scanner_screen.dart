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
    _quantityController.text = "1";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("SKU: $sku"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ingrese cantidad:"),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              autofocus: true, // Para que el teclado salga automáticamente
              decoration: InputDecoration(border: OutlineInputBorder()),
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
    // Se utiliza el metodo updateStock definido en tu ApiService
    final result = await _api.updateStock(sku, qty);

    if (mounted) {
      Navigator.pop(context); // Cerrar diálogo

// 2. LÓGICA DE COLOR DINÁMICA
      // Determinamos el color basándonos en si el mensaje indica caché o éxito real
      Color snackColor;
      String message = result['message'] ?? "Operación exitosa";

      if (message.contains("caché") || message.contains("localmente")) {
        snackColor = Colors.blue; // Azul para indicar "Pendiente de sincronizar"
      } else {
        snackColor = qty > 0 ? Colors.green : Colors.orange[800]!; // Colores normales
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  snackColor == Colors.blue ? Icons.cloud_off : Icons.check_circle,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(child: Text(message)),
              ],
            ),
            backgroundColor: snackColor,
            duration: Duration(seconds: 3),
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