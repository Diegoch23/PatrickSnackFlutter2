import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';

class GeneratorScreen extends StatefulWidget {
  @override
  _GeneratorScreenState createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final _api = ApiService();
  final _screenshotController = ScreenshotController();
  final Box _productsBox = Hive.box('products_cache');

  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _synchronizeProducts();
  }

  _synchronizeProducts() async {
    setState(() => isLoading = true);

    try {
      final data = await _api.getProducts();
      if (data.isNotEmpty) {
        await _productsBox.put('list', data);

        if (mounted) {
          setState(() {
            products = data;
            isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint("Excepción en sincronización remota: $e");
    }

    final cachedData = _productsBox.get('list');
    if (mounted) {
      setState(() {
        if (cachedData != null) products = List<dynamic>.from(cachedData);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.generatorTitle)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(child: Text(l10n.noRecords))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showBarcodeModal(
                    product['sku'].toString(),
                    product['name']
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildProductIcon(),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "SKU: ${product['sku']}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontFamily: 'monospace',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 24, color: Colors.grey[400]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Center(
        child: Transform.rotate(
          angle: 1.5708,
          child: Icon(
              Icons.bar_chart_rounded,
              color: Colors.blueAccent,
              size: 28
          ),
        ),
      ),
    );
  }

  void _showBarcodeModal(String sku, String name) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.codeGenerated, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: sku,
                        width: 300,
                        height: 100,
                        drawText: true,
                        style: TextStyle(fontSize: 14, letterSpacing: 2),
                      ),
                      SizedBox(height: 15),
                      Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _saveBarcodeToGallery();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.save_alt),
                  label: Text(l10n.saveToGallery, style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveBarcodeToGallery() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await Future.delayed(Duration(milliseconds: 150));

      final imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        await Gal.putImageBytes(imageBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text(l10n.imageSaved),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              )
          );
        }
      }
    } catch (e) {
      debugPrint("Error de E/S al guardar imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveError), backgroundColor: Colors.red)
      );
    }
  }
}