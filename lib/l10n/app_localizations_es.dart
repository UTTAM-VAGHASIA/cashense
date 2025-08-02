// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cashense';

  @override
  String get welcome => 'Bienvenido a Cashense';

  @override
  String get tagline => 'Tu compañero financiero con inteligencia artificial';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer Contraseña';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get add => 'Agregar';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get sort => 'Ordenar';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get dashboard => 'Panel';

  @override
  String get accounts => 'Cuentas';

  @override
  String get transactions => 'Transacciones';

  @override
  String get budgets => 'Presupuestos';

  @override
  String get analytics => 'Análisis';

  @override
  String get goals => 'Metas';

  @override
  String get cashbooks => 'Libros de Caja';

  @override
  String get amount => 'Cantidad';

  @override
  String get description => 'Descripción';

  @override
  String get category => 'Categoría';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get currency => 'Moneda';

  @override
  String get balance => 'Saldo';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Gasto';

  @override
  String get transfer => 'Transferencia';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get thisYear => 'Este Año';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get security => 'Seguridad';

  @override
  String get privacy => 'Privacidad';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get done => 'Hecho';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get skip => 'Omitir';

  @override
  String get continueButton => 'Continuar';

  @override
  String get back => 'Atrás';

  @override
  String get home => 'Inicio';

  @override
  String get menu => 'Menú';

  @override
  String get more => 'Más';

  @override
  String get less => 'Menos';

  @override
  String get all => 'Todo';

  @override
  String get none => 'Ninguno';

  @override
  String get select => 'Seleccionar';

  @override
  String get clear => 'Limpiar';

  @override
  String get reset => 'Restablecer';

  @override
  String get refresh => 'Actualizar';

  @override
  String get sync => 'Sincronizar';

  @override
  String get backup => 'Respaldo';

  @override
  String get restore => 'Restaurar';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get share => 'Compartir';

  @override
  String get copy => 'Copiar';

  @override
  String get paste => 'Pegar';

  @override
  String get cut => 'Cortar';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get help => 'Ayuda';

  @override
  String get support => 'Soporte';

  @override
  String get feedback => 'Comentarios';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get licenses => 'Licencias';

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
    return '¡Bienvenido, $name!';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transacciones',
      one: '1 transacción',
      zero: 'Sin transacciones',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return 'Saldo: $amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return '$spent de $budget gastado';
  }

  @override
  String lastUpdated(String date) {
    return 'Última actualización: $date';
  }
}
