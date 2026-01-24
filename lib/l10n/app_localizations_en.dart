// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Patrik\'s Snack';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginTitle => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'LOGIN';

  @override
  String get internetRequired =>
      'Internet connection required for first login.';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get connectionError => 'Connection error with Hostinger';

  @override
  String get homeTitle => 'Patrik\'s Snack';

  @override
  String get homeGreeting => 'Hello👋';

  @override
  String get homeQuestion => 'What would you like to do today?';

  @override
  String get logout => 'Logout';

  @override
  String get syncPending => 'Sync pending';

  @override
  String get offlineMode => 'Offline Mode Active';

  @override
  String pendingRecords(Object count) {
    return 'You have $count records saved locally.';
  }

  @override
  String get generateCodes => 'Generate Codes';

  @override
  String get generateCodesSubtitle => 'Create barcode labels for products';

  @override
  String get scanProduct => 'Scan Product';

  @override
  String get scanProductSubtitle => 'Register entries or sales';

  @override
  String get inventory => 'Inventory';

  @override
  String get inventorySubtitle => 'View current stock';

  @override
  String get logoutDialogTitle => 'Logout';

  @override
  String get logoutDialogMessage => 'Are you sure you want to exit the system?';

  @override
  String get exit => 'EXIT';

  @override
  String get generatorTitle => 'Code Generator';

  @override
  String get loading => 'Loading...';

  @override
  String get noRecords => 'No synchronized records found.';

  @override
  String get codeGenerated => 'Code Generated';

  @override
  String get saveToGallery => 'Save to Gallery';

  @override
  String get imageSaved => 'Image saved successfully';

  @override
  String get saveError => 'Error saving image';

  @override
  String get scannerMode => 'Scanner Mode';

  @override
  String get flashlight => 'Flashlight';

  @override
  String get rotate => 'Rotate';

  @override
  String get productDetected => 'Product Detected';

  @override
  String get description => 'DESCRIPTION:';

  @override
  String get identifier => 'IDENTIFIER (SKU):';

  @override
  String get defineQuantity => 'Define quantity to process:';

  @override
  String get sale => 'SALE';

  @override
  String get entry => 'ENTRY';

  @override
  String get validationError =>
      '⚠️ Validation Error: Enter a quantity greater than 0';

  @override
  String get transactionCompleted => 'Transaction completed';

  @override
  String get inventoryTitle => 'Patrik\'s Snack Inventory';

  @override
  String get searchPlaceholder => 'Search by name or SKU...';

  @override
  String get noProducts => 'No products found';

  @override
  String get offlineData => 'Showing local data (Offline)';

  @override
  String get noConnectionNoCache => 'No connection and no cached data';

  @override
  String get stock => 'STOCK';

  @override
  String get category => 'Cat:';

  @override
  String get unknownProduct => 'Unknown Product';
}
