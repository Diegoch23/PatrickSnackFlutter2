import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';
import '../main.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.orange[800]!, Colors.orange[400]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo y título
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(Icons.language, size: 60, color: Colors.orange[800]),
              ),

              SizedBox(height: 30),

              Text(
                "Patrik's Snack",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),

              SizedBox(height: 10),

              Text(
                AppLocalizations.of(context)!.selectLanguage,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 40),

              // Lista de idiomas
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      itemCount: LanguageService.supportedLanguages.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 70,
                        endIndent: 20,
                      ),
                      itemBuilder: (context, index) {
                        final languageCode = LanguageService.supportedLanguages.keys.elementAt(index);
                        final languageData = LanguageService.supportedLanguages[languageCode]!;
                        final isSelected = selectedLanguage == languageCode;

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange[50] : Colors.grey[100],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.orange : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                languageData['flag']!,
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          title: Text(
                            languageData['name']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.orange[900] : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.orange, size: 28)
                              : Icon(Icons.circle_outlined, color: Colors.grey[400], size: 28),
                          onTap: () {
                            setState(() {
                              selectedLanguage = languageCode;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Botón de continuar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLanguage != null ? Colors.white : Colors.grey[300],
                      foregroundColor: Colors.orange[800],
                      elevation: selectedLanguage != null ? 5 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: selectedLanguage != null
                        ? () async {
                      // Guardar idioma seleccionado
                      await LanguageService.saveLanguage(selectedLanguage!);

                      // APLICAR EL CAMBIO DE IDIOMA INMEDIATAMENTE
                      PatricksApp.setLocale(
                          context,
                          LanguageService.getLocaleFromCode(selectedLanguage!)
                      );

                      // Pequeño delay para que se aplique el cambio
                      await Future.delayed(Duration(milliseconds: 100));

                      // Navegar al login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (c) => LoginScreen()),
                      );
                    }
                        : null,
                    child: Text(
                      AppLocalizations.of(context)!.continueButton,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}