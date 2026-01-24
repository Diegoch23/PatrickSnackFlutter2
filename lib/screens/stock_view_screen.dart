import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';

class StockViewScreen extends StatefulWidget {
  @override
  _StockViewScreenState createState() => _StockViewScreenState();
}

class _StockViewScreenState extends State<StockViewScreen> {
  final ApiService _api = ApiService();
  final Box _productsBox = Hive.box('products_cache');

  List<dynamic> allProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStock();
  }

  Future<void> _loadStock() async {
    setState(() => isLoading = true);

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final data = await _api.getProducts();

        await _productsBox.put('list', data);
        await _productsBox.put('last_update', DateTime.now().toIso8601String());
        if (mounted) {
          setState(() {
            allProducts = data;
            filteredProducts = data;
            isLoading = false;
          });
        }
        return;
      } catch (e) {
        print("Error API, intentando cargar caché...");
      }
    }

    final cachedData = _productsBox.get('list');
    if (cachedData != null) {
      setState(() {
        allProducts = List<dynamic>.from(cachedData);
        filteredProducts = allProducts;
        isLoading = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.offlineData),
            backgroundColor: Colors.blueGrey,
          ),
        );
      }
    } else {
      setState(() => isLoading = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noConnectionNoCache)),
        );
      }
    }
  }

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryTitle),
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                labelText: l10n.searchPlaceholder,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadStock,
              child: filteredProducts.isEmpty
                  ? Center(child: Text(l10n.noProducts))
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(Icons.tag, "SKU: ${p['sku']}"),
                                    SizedBox(height: 4),
                                    _infoRow(Icons.category, "${l10n.category} ${p['category']['name']}"),
                                  ],
                                ),
                              ),

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
                                      l10n.stock,
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