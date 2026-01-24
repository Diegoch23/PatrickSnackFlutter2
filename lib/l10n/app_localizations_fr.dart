// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Patrik\'s Snack';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get continueButton => 'Continuer';

  @override
  String get cancel => 'Annuler';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'CONNEXION';

  @override
  String get internetRequired =>
      'Connexion Internet requise pour la première connexion.';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String get connectionError => 'Erreur de connexion avec Hostinger';

  @override
  String get homeTitle => 'Patrik\'s Snack';

  @override
  String get homeGreeting => 'Bonjour👋';

  @override
  String get homeQuestion => 'Que souhaitez-vous faire aujourd\'hui?';

  @override
  String get logout => 'Déconnexion';

  @override
  String get syncPending => 'Synchroniser en attente';

  @override
  String get offlineMode => 'Mode hors ligne actif';

  @override
  String pendingRecords(Object count) {
    return 'Vous avez $count enregistrements sauvegardés localement.';
  }

  @override
  String get generateCodes => 'Générer des codes';

  @override
  String get generateCodesSubtitle =>
      'Créer des étiquettes de codes-barres pour les produits';

  @override
  String get scanProduct => 'Scanner le produit';

  @override
  String get scanProductSubtitle => 'Enregistrer les entrées ou les ventes';

  @override
  String get inventory => 'Inventaire';

  @override
  String get inventorySubtitle => 'Voir le stock actuel';

  @override
  String get logoutDialogTitle => 'Déconnexion';

  @override
  String get logoutDialogMessage =>
      'Êtes-vous sûr de vouloir quitter le système?';

  @override
  String get exit => 'SORTIR';

  @override
  String get generatorTitle => 'Générateur de codes';

  @override
  String get loading => 'Chargement...';

  @override
  String get noRecords => 'Aucun enregistrement synchronisé trouvé.';

  @override
  String get codeGenerated => 'Code généré';

  @override
  String get saveToGallery => 'Enregistrer dans la galerie';

  @override
  String get imageSaved => 'Image enregistrée avec succès';

  @override
  String get saveError => 'Erreur lors de l\'enregistrement de l\'image';

  @override
  String get scannerMode => 'Mode scanner';

  @override
  String get flashlight => 'Lampe de poche';

  @override
  String get rotate => 'Rotation';

  @override
  String get productDetected => 'Produit détecté';

  @override
  String get description => 'DESCRIPTION:';

  @override
  String get identifier => 'IDENTIFIANT (SKU):';

  @override
  String get defineQuantity => 'Définir la quantité à traiter:';

  @override
  String get sale => 'VENTE';

  @override
  String get entry => 'ENTRÉE';

  @override
  String get validationError =>
      '⚠️ Erreur de validation: Entrez une quantité supérieure à 0';

  @override
  String get transactionCompleted => 'Transaction terminée';

  @override
  String get inventoryTitle => 'Inventaire Patrik\'s Snack';

  @override
  String get searchPlaceholder => 'Rechercher par nom ou SKU...';

  @override
  String get noProducts => 'Aucun produit trouvé';

  @override
  String get offlineData => 'Affichage des données locales (Hors ligne)';

  @override
  String get noConnectionNoCache =>
      'Pas de connexion et pas de données en cache';

  @override
  String get stock => 'STOCK';

  @override
  String get category => 'Cat:';

  @override
  String get unknownProduct => 'Produit inconnu';
}
