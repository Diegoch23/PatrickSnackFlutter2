import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _api = ApiService();
  bool _isLoading = false;

  void _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    // 1. Verificar conexión antes de intentar loguear
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.internetRequired),
          backgroundColor: Colors.blueGrey,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Intentar login contra la API de Laravel
      bool success = await _api.login(_emailController.text, _passController.text);
      setState(() => _isLoading = false);

      if (success) {
        // Al tener éxito, el token ya se guarda dentro de api.login
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => HomeScreen())
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.invalidCredentials), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.connectionError), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.orange[800]!, Colors.orange[400]!],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo circular
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(Icons.fastfood, size: 60, color: Colors.orange[800]),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: l10n.email,
                            prefixIcon: Icon(Icons.email)
                        ),
                      ),
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: l10n.password,
                            prefixIcon: Icon(Icons.lock)
                        ),
                      ),
                      SizedBox(height: 30),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                            l10n.login,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}