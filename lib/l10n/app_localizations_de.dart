// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Patrik\'s Snack';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get continueButton => 'Fortsetzen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get login => 'ANMELDEN';

  @override
  String get internetRequired =>
      'Internetverbindung für erste Anmeldung erforderlich.';

  @override
  String get invalidCredentials => 'Ungültige Anmeldedaten';

  @override
  String get connectionError => 'Verbindungsfehler mit Hostinger';

  @override
  String get homeTitle => 'Patrik\'s Snack';

  @override
  String get homeGreeting => 'Hallo👋';

  @override
  String get homeQuestion => 'Was möchten Sie heute tun?';

  @override
  String get logout => 'Abmelden';

  @override
  String get syncPending => 'Ausstehende synchronisieren';

  @override
  String get offlineMode => 'Offline-Modus aktiv';

  @override
  String pendingRecords(Object count) {
    return 'Sie haben $count lokal gespeicherte Datensätze.';
  }

  @override
  String get generateCodes => 'Codes generieren';

  @override
  String get generateCodesSubtitle =>
      'Barcode-Etiketten für Produkte erstellen';

  @override
  String get scanProduct => 'Produkt scannen';

  @override
  String get scanProductSubtitle => 'Eingänge oder Verkäufe registrieren';

  @override
  String get inventory => 'Inventar';

  @override
  String get inventorySubtitle => 'Aktuellen Bestand anzeigen';

  @override
  String get logoutDialogTitle => 'Abmelden';

  @override
  String get logoutDialogMessage =>
      'Sind Sie sicher, dass Sie das System verlassen möchten?';

  @override
  String get exit => 'BEENDEN';

  @override
  String get generatorTitle => 'Code-Generator';

  @override
  String get loading => 'Laden...';

  @override
  String get noRecords => 'Keine synchronisierten Datensätze gefunden.';

  @override
  String get codeGenerated => 'Code generiert';

  @override
  String get saveToGallery => 'In Galerie speichern';

  @override
  String get imageSaved => 'Bild erfolgreich gespeichert';

  @override
  String get saveError => 'Fehler beim Speichern des Bildes';

  @override
  String get scannerMode => 'Scanner-Modus';

  @override
  String get flashlight => 'Taschenlampe';

  @override
  String get rotate => 'Drehen';

  @override
  String get productDetected => 'Produkt erkannt';

  @override
  String get description => 'BESCHREIBUNG:';

  @override
  String get identifier => 'KENNUNG (SKU):';

  @override
  String get defineQuantity => 'Zu verarbeitende Menge definieren:';

  @override
  String get sale => 'VERKAUF';

  @override
  String get entry => 'EINGANG';

  @override
  String get validationError =>
      '⚠️ Validierungsfehler: Geben Sie eine Menge größer als 0 ein';

  @override
  String get transactionCompleted => 'Transaktion abgeschlossen';

  @override
  String get inventoryTitle => 'Patrik\'s Snack Inventar';

  @override
  String get searchPlaceholder => 'Nach Name oder SKU suchen...';

  @override
  String get noProducts => 'Keine Produkte gefunden';

  @override
  String get offlineData => 'Lokale Daten anzeigen (Offline)';

  @override
  String get noConnectionNoCache =>
      'Keine Verbindung und keine zwischengespeicherten Daten';

  @override
  String get stock => 'BESTAND';

  @override
  String get category => 'Kat:';

  @override
  String get unknownProduct => 'Unbekanntes Produkt';
}
