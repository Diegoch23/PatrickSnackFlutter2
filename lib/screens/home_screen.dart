import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'generator_screen.dart';
import 'scanner_screen.dart';
import 'stock_view_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeSyncListeners();
  }

  void _initializeSyncListeners() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _api.syncPendingData();
      }
    });
    _api.syncPendingData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          l10n.homeTitle,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: Hive.box('pending_sync').listenable(),
            builder: (context, Box box, widget) {
              if (box.isEmpty) return SizedBox.shrink();

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.cloud_upload_outlined, color: Colors.blueAccent),
                    onPressed: () => _api.syncPendingData(),
                    tooltip: l10n.syncPending,
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        box.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black54),
            tooltip: l10n.logout,
            onPressed: () => _showLogoutDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeGreeting,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            Text(
              l10n.homeQuestion,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey[400]),
            ),

            SizedBox(height: 25),

            ValueListenableBuilder(
              valueListenable: Hive.box('pending_sync').listenable(),
              builder: (context, Box box, widget) {
                if (box.isEmpty) return SizedBox.shrink();

                return Container(
                  margin: EdgeInsets.only(bottom: 25),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(Icons.wifi_off, color: Colors.orange, size: 20),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.offlineMode, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[900])),
                            SizedBox(height: 4),
                            Text(
                              l10n.pendingRecords(box.length),
                              style: TextStyle(fontSize: 12, color: Colors.orange[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            _buildDashboardCard(
              context,
              title: l10n.generateCodes,
              subtitle: l10n.generateCodesSubtitle,
              icon: Icons.qr_code_2,
              startColor: Color(0xFF4FACFE),
              endColor: Color(0xFF00F2FE),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => GeneratorScreen())),
            ),

            SizedBox(height: 20),

            _buildDashboardCard(
              context,
              title: l10n.scanProduct,
              subtitle: l10n.scanProductSubtitle,
              icon: Icons.qr_code_scanner,
              startColor: Color(0xFFFA709A),
              endColor: Color(0xFFFEE140),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ScannerScreen())),
            ),

            SizedBox(height: 20),

            _buildDashboardCard(
              context,
              title: l10n.inventory,
              subtitle: l10n.inventorySubtitle,
              icon: Icons.inventory_2_outlined,
              startColor: Color(0xFF43E97B),
              endColor: Color(0xFF38F9D7),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => StockViewScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color startColor,
    required Color endColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(l10n.logoutDialogTitle),
        content: Text(l10n.logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel.toUpperCase(), style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LoginScreen()),
                    (route) => false,
              );
            },
            child: Text(l10n.exit, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}