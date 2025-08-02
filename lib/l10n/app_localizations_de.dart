// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Cashense';

  @override
  String get welcome => 'Willkommen bei Cashense';

  @override
  String get tagline => 'Ihr KI-gestützter Finanzbegleiter';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signUp => 'Registrieren';

  @override
  String get signOut => 'Abmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort Bestätigen';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get resetPassword => 'Passwort Zurücksetzen';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get search => 'Suchen';

  @override
  String get filter => 'Filtern';

  @override
  String get sort => 'Sortieren';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get accounts => 'Konten';

  @override
  String get transactions => 'Transaktionen';

  @override
  String get budgets => 'Budgets';

  @override
  String get analytics => 'Analysen';

  @override
  String get goals => 'Ziele';

  @override
  String get cashbooks => 'Kassenbücher';

  @override
  String get amount => 'Betrag';

  @override
  String get description => 'Beschreibung';

  @override
  String get category => 'Kategorie';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get currency => 'Währung';

  @override
  String get balance => 'Saldo';

  @override
  String get income => 'Einkommen';

  @override
  String get expense => 'Ausgabe';

  @override
  String get transfer => 'Überweisung';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get thisYear => 'Dieses Jahr';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get systemTheme => 'System';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get security => 'Sicherheit';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get info => 'Information';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get retry => 'Wiederholen';

  @override
  String get close => 'Schließen';

  @override
  String get done => 'Fertig';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get skip => 'Überspringen';

  @override
  String get continueButton => 'Fortfahren';

  @override
  String get back => 'Zurück';

  @override
  String get home => 'Startseite';

  @override
  String get menu => 'Menü';

  @override
  String get more => 'Mehr';

  @override
  String get less => 'Weniger';

  @override
  String get all => 'Alle';

  @override
  String get none => 'Keine';

  @override
  String get select => 'Auswählen';

  @override
  String get clear => 'Löschen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get sync => 'Synchronisieren';

  @override
  String get backup => 'Sicherung';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get import => 'Importieren';

  @override
  String get export => 'Exportieren';

  @override
  String get share => 'Teilen';

  @override
  String get copy => 'Kopieren';

  @override
  String get paste => 'Einfügen';

  @override
  String get cut => 'Ausschneiden';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get help => 'Hilfe';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get contactUs => 'Kontakt';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get licenses => 'Lizenzen';

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
    return 'Willkommen, $name!';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Transaktionen',
      one: '1 Transaktion',
      zero: 'Keine Transaktionen',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return 'Saldo: $amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return '$spent von $budget ausgegeben';
  }

  @override
  String lastUpdated(String date) {
    return 'Zuletzt aktualisiert: $date';
  }
}
