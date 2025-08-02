// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كاشنس';

  @override
  String get welcome => 'مرحباً بك في كاشنس';

  @override
  String get tagline => 'رفيقك المالي المدعوم بالذكاء الاصطناعي';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get sort => 'ترتيب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get accounts => 'الحسابات';

  @override
  String get transactions => 'المعاملات';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get goals => 'الأهداف';

  @override
  String get cashbooks => 'دفاتر النقد';

  @override
  String get amount => 'المبلغ';

  @override
  String get description => 'الوصف';

  @override
  String get category => 'الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get currency => 'العملة';

  @override
  String get balance => 'الرصيد';

  @override
  String get income => 'الدخل';

  @override
  String get expense => 'المصروف';

  @override
  String get transfer => 'تحويل';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisYear => 'هذا العام';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get security => 'الأمان';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get done => 'تم';

  @override
  String get next => 'التالي';

  @override
  String get previous => 'السابق';

  @override
  String get skip => 'تخطي';

  @override
  String get continueButton => 'متابعة';

  @override
  String get back => 'رجوع';

  @override
  String get home => 'الرئيسية';

  @override
  String get menu => 'القائمة';

  @override
  String get more => 'المزيد';

  @override
  String get less => 'أقل';

  @override
  String get all => 'الكل';

  @override
  String get none => 'لا شيء';

  @override
  String get select => 'اختيار';

  @override
  String get clear => 'مسح';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get refresh => 'تحديث';

  @override
  String get sync => 'مزامنة';

  @override
  String get backup => 'نسخ احتياطي';

  @override
  String get restore => 'استعادة';

  @override
  String get import => 'استيراد';

  @override
  String get export => 'تصدير';

  @override
  String get share => 'مشاركة';

  @override
  String get copy => 'نسخ';

  @override
  String get paste => 'لصق';

  @override
  String get cut => 'قص';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get help => 'مساعدة';

  @override
  String get support => 'الدعم';

  @override
  String get feedback => 'التعليقات';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get licenses => 'التراخيص';

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
    return 'مرحباً، $name!';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count معاملة',
      many: '$count معاملة',
      few: '$count معاملات',
      two: 'معاملتان',
      one: 'معاملة واحدة',
      zero: 'لا توجد معاملات',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return 'الرصيد: $amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return 'تم إنفاق $spent من $budget';
  }

  @override
  String lastUpdated(String date) {
    return 'آخر تحديث: $date';
  }
}
