// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Cashense';

  @override
  String get welcome => 'Bienvenue sur Cashense';

  @override
  String get tagline => 'Votre compagnon financier alimenté par l\'IA';

  @override
  String get signIn => 'Se Connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de Passe';

  @override
  String get confirmPassword => 'Confirmer le Mot de Passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le Mot de Passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get phoneNumber => 'Numéro de Téléphone';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get accounts => 'Comptes';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get analytics => 'Analyses';

  @override
  String get goals => 'Objectifs';

  @override
  String get cashbooks => 'Livres de Caisse';

  @override
  String get amount => 'Montant';

  @override
  String get description => 'Description';

  @override
  String get category => 'Catégorie';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get currency => 'Devise';

  @override
  String get balance => 'Solde';

  @override
  String get income => 'Revenu';

  @override
  String get expense => 'Dépense';

  @override
  String get transfer => 'Virement';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get thisMonth => 'Ce Mois';

  @override
  String get thisYear => 'Cette Année';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Sécurité';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get about => 'À Propos';

  @override
  String get version => 'Version';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Information';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get retry => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get done => 'Terminé';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get skip => 'Ignorer';

  @override
  String get continueButton => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get home => 'Accueil';

  @override
  String get menu => 'Menu';

  @override
  String get more => 'Plus';

  @override
  String get less => 'Moins';

  @override
  String get all => 'Tout';

  @override
  String get none => 'Aucun';

  @override
  String get select => 'Sélectionner';

  @override
  String get clear => 'Effacer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get refresh => 'Actualiser';

  @override
  String get sync => 'Synchroniser';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get restore => 'Restaurer';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Exporter';

  @override
  String get share => 'Partager';

  @override
  String get copy => 'Copier';

  @override
  String get paste => 'Coller';

  @override
  String get cut => 'Couper';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Refaire';

  @override
  String get help => 'Aide';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Commentaires';

  @override
  String get contactUs => 'Nous Contacter';

  @override
  String get termsOfService => 'Conditions d\'Utilisation';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get licenses => 'Licences';

  @override
  String currencyFormat(String amount) {
    return '$amount';
  }

  @override
  String dateFormat(String date) {
    return '$date';
  }

  @override
  String timeFormat(String time) {
    return '$time';
  }

  @override
  String welcomeUser(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'Aucune transaction',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return 'Solde : $amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return '$spent sur $budget dépensé';
  }

  @override
  String lastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }
}
