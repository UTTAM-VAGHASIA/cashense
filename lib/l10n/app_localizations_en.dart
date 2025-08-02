// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cashense';

  @override
  String get welcome => 'Welcome to Cashense';

  @override
  String get tagline => 'Your AI-powered financial companion';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get accounts => 'Accounts';

  @override
  String get transactions => 'Transactions';

  @override
  String get budgets => 'Budgets';

  @override
  String get analytics => 'Analytics';

  @override
  String get goals => 'Goals';

  @override
  String get cashbooks => 'Cashbooks';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get currency => 'Currency';

  @override
  String get balance => 'Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get transfer => 'Transfer';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get privacy => 'Privacy';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get skip => 'Skip';

  @override
  String get continueButton => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get home => 'Home';

  @override
  String get menu => 'Menu';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get all => 'All';

  @override
  String get none => 'None';

  @override
  String get select => 'Select';

  @override
  String get clear => 'Clear';

  @override
  String get reset => 'Reset';

  @override
  String get refresh => 'Refresh';

  @override
  String get sync => 'Sync';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get cut => 'Cut';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get help => 'Help';

  @override
  String get support => 'Support';

  @override
  String get feedback => 'Feedback';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get licenses => 'Licenses';

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
    return 'Welcome, $name!';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return 'Balance: $amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return '$spent of $budget spent';
  }

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }
}
