// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Cashense';

  @override
  String get welcome => '欢迎使用 Cashense';

  @override
  String get tagline => '您的AI驱动财务伴侣';

  @override
  String get signIn => '登录';

  @override
  String get signUp => '注册';

  @override
  String get signOut => '退出登录';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get resetPassword => '重置密码';

  @override
  String get firstName => '名';

  @override
  String get lastName => '姓';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get add => '添加';

  @override
  String get search => '搜索';

  @override
  String get filter => '筛选';

  @override
  String get sort => '排序';

  @override
  String get settings => '设置';

  @override
  String get profile => '个人资料';

  @override
  String get dashboard => '仪表板';

  @override
  String get accounts => '账户';

  @override
  String get transactions => '交易';

  @override
  String get budgets => '预算';

  @override
  String get analytics => '分析';

  @override
  String get goals => '目标';

  @override
  String get cashbooks => '账本';

  @override
  String get amount => '金额';

  @override
  String get description => '描述';

  @override
  String get category => '类别';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get currency => '货币';

  @override
  String get balance => '余额';

  @override
  String get income => '收入';

  @override
  String get expense => '支出';

  @override
  String get transfer => '转账';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get thisYear => '今年';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get systemTheme => '系统';

  @override
  String get notifications => '通知';

  @override
  String get security => '安全';

  @override
  String get privacy => '隐私';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get retry => '重试';

  @override
  String get close => '关闭';

  @override
  String get done => '完成';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get skip => '跳过';

  @override
  String get continueButton => '继续';

  @override
  String get back => '返回';

  @override
  String get home => '首页';

  @override
  String get menu => '菜单';

  @override
  String get more => '更多';

  @override
  String get less => '更少';

  @override
  String get all => '全部';

  @override
  String get none => '无';

  @override
  String get select => '选择';

  @override
  String get clear => '清除';

  @override
  String get reset => '重置';

  @override
  String get refresh => '刷新';

  @override
  String get sync => '同步';

  @override
  String get backup => '备份';

  @override
  String get restore => '恢复';

  @override
  String get import => '导入';

  @override
  String get export => '导出';

  @override
  String get share => '分享';

  @override
  String get copy => '复制';

  @override
  String get paste => '粘贴';

  @override
  String get cut => '剪切';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get help => '帮助';

  @override
  String get support => '支持';

  @override
  String get feedback => '反馈';

  @override
  String get contactUs => '联系我们';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get licenses => '许可证';

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
    return '欢迎，$name！';
  }

  @override
  String transactionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count笔交易',
      one: '1笔交易',
      zero: '无交易',
    );
    return '$_temp0';
  }

  @override
  String accountBalance(String amount) {
    return '余额：$amount';
  }

  @override
  String budgetProgress(String spent, String budget) {
    return '已花费 $spent，预算 $budget';
  }

  @override
  String lastUpdated(String date) {
    return '最后更新：$date';
  }
}
