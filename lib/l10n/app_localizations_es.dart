// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Patrik\'s Snack';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get continueButton => 'Continuar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'INGRESAR';

  @override
  String get internetRequired =>
      'Se requiere internet para el primer inicio de sesión.';

  @override
  String get invalidCredentials => 'Credenciales incorrectas';

  @override
  String get connectionError => 'Error de conexión con Hostinger';

  @override
  String get homeTitle => 'Patrik\'s Snack';

  @override
  String get homeGreeting => 'Hola👋';

  @override
  String get homeQuestion => '¿Qué deseas hacer hoy?';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get syncPending => 'Sincronizar pendientes';

  @override
  String get offlineMode => 'Modo Offline Activo';

  @override
  String pendingRecords(Object count) {
    return 'Tienes $count registros guardados localmente.';
  }

  @override
  String get generateCodes => 'Generar Códigos';

  @override
  String get generateCodesSubtitle => 'Crea etiquetas en barra para productos';

  @override
  String get scanProduct => 'Escanear Producto';

  @override
  String get scanProductSubtitle => 'Registra entradas o ventas';

  @override
  String get inventory => 'Inventario';

  @override
  String get inventorySubtitle => 'Visualiza el stock actual';

  @override
  String get logoutDialogTitle => 'Cerrar Sesión';

  @override
  String get logoutDialogMessage =>
      '¿Estás seguro de que deseas salir del sistema?';

  @override
  String get exit => 'SALIR';

  @override
  String get generatorTitle => 'Generador de Códigos';

  @override
  String get loading => 'Cargando...';

  @override
  String get noRecords => 'No se encontraron registros sincronizados.';

  @override
  String get codeGenerated => 'Código Generado';

  @override
  String get saveToGallery => 'Guardar en Galería';

  @override
  String get imageSaved => 'Imagen guardada exitosamente';

  @override
  String get saveError => 'Error al guardar la imagen';

  @override
  String get scannerMode => 'Modo Escáner';

  @override
  String get flashlight => 'Linterna';

  @override
  String get rotate => 'Rotar';

  @override
  String get productDetected => 'Producto Detectado';

  @override
  String get description => 'DESCRIPCIÓN:';

  @override
  String get identifier => 'IDENTIFICADOR (SKU):';

  @override
  String get defineQuantity => 'Defina la cantidad a procesar:';

  @override
  String get sale => 'VENTA';

  @override
  String get entry => 'INGRESO';

  @override
  String get validationError =>
      '⚠️ Error de Validación: Ingrese una cantidad mayor a 0';

  @override
  String get transactionCompleted => 'Transacción completada';

  @override
  String get inventoryTitle => 'Inventario Patrik\'s Snack';

  @override
  String get searchPlaceholder => 'Buscar por nombre o SKU...';

  @override
  String get noProducts => 'No se encontraron productos';

  @override
  String get offlineData => 'Mostrando datos locales (Offline)';

  @override
  String get noConnectionNoCache => 'Sin conexión y sin datos en caché';

  @override
  String get stock => 'STOCK';

  @override
  String get category => 'Cat:';

  @override
  String get unknownProduct => 'Producto No Identificado';
}
