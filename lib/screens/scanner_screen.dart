import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _api = ApiService();
  final TextEditingController _quantityController = TextEditingController();
  final Box _productsBox = Hive.box('products_cache');

  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    _ensureDataConsistency();
  }

  void _ensureDataConsistency() async {
    final cachedData = _productsBox.get('list');

    if (cachedData == null || (cachedData as List).isEmpty) {
      debugPrint("Caché vacía en Scanner. Iniciando descarga silenciosa...");
      try {
        final freshData = await _api.getProducts();
        if (freshData.isNotEmpty) {
          await _productsBox.put('list', freshData);
          debugPrint("Datos sincronizados en Scanner exitosamente.");
        }
      } catch (e) {
        debugPrint("Fallo en sincronización silenciosa: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String detectedSku = barcodes.first.rawValue!;

      setState(() => isScanning = false);

      final l10n = AppLocalizations.of(context)!;
      String productName = l10n.unknownProduct;

      try {
        final List rawList = _productsBox.get('list', defaultValue: []);

        final productFound = rawList.firstWhere(
                (element) => element['sku'].toString().trim() == detectedSku.trim(),
            orElse: () => null
        );

        if (productFound != null) {
          productName = productFound['name'];
        }
      } catch (e) {
        debugPrint("Error en consulta local de producto: $e");
      }

      _showTransactionDialog(detectedSku, productName);
    }
  }

  void _showTransactionDialog(String sku, String productName) {
    final l10n = AppLocalizations.of(context)!;
    _quantityController.text = "1";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                      l10n.productDetected,
                      style: TextStyle(fontSize: 18, color: Colors.blue[900], fontWeight: FontWeight.bold)
                  )
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.description, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  SizedBox(height: 4),
                  Text(
                      productName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)
                  ),

                  Divider(height: 20, thickness: 1),

                  Text(l10n.identifier, style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  SizedBox(height: 2),
                  Text(
                      sku,
                      style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: Colors.blueGrey[800])
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            Center(child: Text(l10n.defineQuantity, style: TextStyle(color: Colors.grey[700], fontSize: 13))),
            SizedBox(height: 10),

            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              autofocus: true,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.calculate_outlined),
                hintText: "#",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanning = true);
            },
            child: Text(l10n.cancel.toUpperCase(), style: TextStyle(color: Colors.grey)),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _executeTransaction(sku, isSale: true),
                  icon: Icon(Icons.remove_circle_outline, color: Colors.white, size: 16),
                  label: Text(l10n.sale),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _executeTransaction(sku, isSale: false),
                  icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 16),
                  label: Text(l10n.entry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _executeTransaction(String sku, {required bool isSale}) {
    final l10n = AppLocalizations.of(context)!;
    int qty = int.tryParse(_quantityController.text) ?? 0;

    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.validationError))
      );
      return;
    }

    int finalQty = isSale ? -qty : qty;
    _commitToBackend(sku, finalQty);
  }

  void _commitToBackend(String sku, int qty) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _api.updateStock(sku, qty);

    if (mounted) {
      Navigator.pop(context);

      Color snackColor;
      IconData icon;
      String message = result['message'] ?? l10n.transactionCompleted;

      if (message.toLowerCase().contains("caché") || message.toLowerCase().contains("localmente")) {
        snackColor = Colors.blueAccent;
        icon = Icons.cloud_off;
      } else if (message.toLowerCase().contains("error")) {
        snackColor = Colors.redAccent;
        icon = Icons.error_outline;
      } else {
        snackColor = qty > 0 ? Colors.green : Colors.orange[800]!;
        icon = Icons.check_circle_outline;
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(10),
            content: Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Expanded(child: Text(message, style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
            backgroundColor: snackColor,
            duration: Duration(seconds: 3),
          )
      );

      setState(() => isScanning = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),

          _buildScanOverlay(),

          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        l10n.scannerMode,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHardwareControlButton(
                  icon: Icons.flash_on,
                  label: l10n.flashlight,
                  onTap: () => _cameraController.toggleTorch(),
                ),
                SizedBox(width: 40),
                _buildHardwareControlButton(
                  icon: Icons.cameraswitch,
                  label: l10n.rotate,
                  onTap: () => _cameraController.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Container(
      decoration: ShapeDecoration(
        shape: QrScannerOverlayShape(
          borderColor: Colors.blueAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  Widget _buildHardwareControlButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)
                ]
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        SizedBox(height: 8),
        Text(
            label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)]
            )
        )
      ],
    );
  }
}

// Clase auxiliar QrScannerOverlayShape (mantener igual)
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 10.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 10,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _cutOutSize = cutOutSize != null && cutOutSize < width
        ? cutOutSize
        : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutSize / 2 + borderOffset,
      rect.top + height / 2 - _cutOutSize / 2 + borderOffset,
      _cutOutSize - borderOffset * 2,
      _cutOutSize - borderOffset * 2,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();

    final borderPath = _getBorderPath(cutOutRect, borderLength);
    canvas.drawPath(borderPath, borderPaint);
  }

  Path _getBorderPath(Rect rect, double length) {
    final path = Path();
    path.moveTo(rect.left, rect.top + length);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + length, rect.top);
    path.moveTo(rect.right - length, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + length);
    path.moveTo(rect.right, rect.bottom - length);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - length, rect.bottom);
    path.moveTo(rect.left + length, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - length);
    return path;
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}