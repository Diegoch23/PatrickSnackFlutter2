import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Patrik\'s Snack'**
  String get appTitle;

  /// No description provided for @selectLanguage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Idioma'**
  String get selectLanguage;

  /// No description provided for @continueButton.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @login.
  ///
  /// In es, this message translates to:
  /// **'INGRESAR'**
  String get login;

  /// No description provided for @internetRequired.
  ///
  /// In es, this message translates to:
  /// **'Se requiere internet para el primer inicio de sesión.'**
  String get internetRequired;

  /// No description provided for @invalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Credenciales incorrectas'**
  String get invalidCredentials;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión con Hostinger'**
  String get connectionError;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Patrik\'s Snack'**
  String get homeTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola👋'**
  String get homeGreeting;

  /// No description provided for @homeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué deseas hacer hoy?'**
  String get homeQuestion;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @syncPending.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar pendientes'**
  String get syncPending;

  /// No description provided for @offlineMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Offline Activo'**
  String get offlineMode;

  /// No description provided for @pendingRecords.
  ///
  /// In es, this message translates to:
  /// **'Tienes {count} registros guardados localmente.'**
  String pendingRecords(Object count);

  /// No description provided for @generateCodes.
  ///
  /// In es, this message translates to:
  /// **'Generar Códigos'**
  String get generateCodes;

  /// No description provided for @generateCodesSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea etiquetas en barra para productos'**
  String get generateCodesSubtitle;

  /// No description provided for @scanProduct.
  ///
  /// In es, this message translates to:
  /// **'Escanear Producto'**
  String get scanProduct;

  /// No description provided for @scanProductSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Registra entradas o ventas'**
  String get scanProductSubtitle;

  /// No description provided for @inventory.
  ///
  /// In es, this message translates to:
  /// **'Inventario'**
  String get inventory;

  /// No description provided for @inventorySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Visualiza el stock actual'**
  String get inventorySubtitle;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas salir del sistema?'**
  String get logoutDialogMessage;

  /// No description provided for @exit.
  ///
  /// In es, this message translates to:
  /// **'SALIR'**
  String get exit;

  /// No description provided for @generatorTitle.
  ///
  /// In es, this message translates to:
  /// **'Generador de Códigos'**
  String get generatorTitle;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @noRecords.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron registros sincronizados.'**
  String get noRecords;

  /// No description provided for @codeGenerated.
  ///
  /// In es, this message translates to:
  /// **'Código Generado'**
  String get codeGenerated;

  /// No description provided for @saveToGallery.
  ///
  /// In es, this message translates to:
  /// **'Guardar en Galería'**
  String get saveToGallery;

  /// No description provided for @imageSaved.
  ///
  /// In es, this message translates to:
  /// **'Imagen guardada exitosamente'**
  String get imageSaved;

  /// No description provided for @saveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar la imagen'**
  String get saveError;

  /// No description provided for @scannerMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Escáner'**
  String get scannerMode;

  /// No description provided for @flashlight.
  ///
  /// In es, this message translates to:
  /// **'Linterna'**
  String get flashlight;

  /// No description provided for @rotate.
  ///
  /// In es, this message translates to:
  /// **'Rotar'**
  String get rotate;

  /// No description provided for @productDetected.
  ///
  /// In es, this message translates to:
  /// **'Producto Detectado'**
  String get productDetected;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'DESCRIPCIÓN:'**
  String get description;

  /// No description provided for @identifier.
  ///
  /// In es, this message translates to:
  /// **'IDENTIFICADOR (SKU):'**
  String get identifier;

  /// No description provided for @defineQuantity.
  ///
  /// In es, this message translates to:
  /// **'Defina la cantidad a procesar:'**
  String get defineQuantity;

  /// No description provided for @sale.
  ///
  /// In es, this message translates to:
  /// **'VENTA'**
  String get sale;

  /// No description provided for @entry.
  ///
  /// In es, this message translates to:
  /// **'INGRESO'**
  String get entry;

  /// No description provided for @validationError.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Error de Validación: Ingrese una cantidad mayor a 0'**
  String get validationError;

  /// No description provided for @transactionCompleted.
  ///
  /// In es, this message translates to:
  /// **'Transacción completada'**
  String get transactionCompleted;

  /// No description provided for @inventoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Inventario Patrik\'s Snack'**
  String get inventoryTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o SKU...'**
  String get searchPlaceholder;

  /// No description provided for @noProducts.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get noProducts;

  /// No description provided for @offlineData.
  ///
  /// In es, this message translates to:
  /// **'Mostrando datos locales (Offline)'**
  String get offlineData;

  /// No description provided for @noConnectionNoCache.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión y sin datos en caché'**
  String get noConnectionNoCache;

  /// No description provided for @stock.
  ///
  /// In es, this message translates to:
  /// **'STOCK'**
  String get stock;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Cat:'**
  String get category;

  /// No description provided for @unknownProduct.
  ///
  /// In es, this message translates to:
  /// **'Producto No Identificado'**
  String get unknownProduct;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
