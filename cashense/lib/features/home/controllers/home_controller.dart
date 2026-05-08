import 'package:get/get.dart';
import 'package:cashense/data/models/transaction_model.dart';

/// Aggregated state powering the home dashboard.
///
/// Phase 1.1 ships an empty-state scaffold — transaction, account, and budget
/// repositories don't exist yet (Phase 1.2 / 1.3 / 1.4). Once those land,
/// replace the stubs in [_loadDashboard] with real reads and recompute on
/// repository streams.
class HomeController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxDouble _totalBalance = 0.0.obs;
  final RxDouble _monthlyIncome = 0.0.obs;
  final RxDouble _monthlyExpense = 0.0.obs;
  final RxList<TransactionModel> _recentTransactions = <TransactionModel>[].obs;
  final RxList<CategoryBudgetUsage> _budgetUsage = <CategoryBudgetUsage>[].obs;

  bool get isLoading => _isLoading.value;
  double get totalBalance => _totalBalance.value;
  double get monthlyIncome => _monthlyIncome.value;
  double get monthlyExpense => _monthlyExpense.value;
  double get monthlyNet => _monthlyIncome.value - _monthlyExpense.value;
  List<TransactionModel> get recentTransactions => _recentTransactions;
  List<CategoryBudgetUsage> get budgetUsage => _budgetUsage;
  bool get hasNoData =>
      _recentTransactions.isEmpty &&
      _totalBalance.value == 0 &&
      _budgetUsage.isEmpty;

  RxBool get isLoadingObs => _isLoading;
  RxDouble get totalBalanceObs => _totalBalance;
  RxDouble get monthlyIncomeObs => _monthlyIncome;
  RxDouble get monthlyExpenseObs => _monthlyExpense;
  RxList<TransactionModel> get recentTransactionsObs => _recentTransactions;
  RxList<CategoryBudgetUsage> get budgetUsageObs => _budgetUsage;

  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  Future<void> refreshDashboard() => _loadDashboard();

  Future<void> _loadDashboard() async {
    _isLoading.value = true;
    try {
      _totalBalance.value = 0;
      _monthlyIncome.value = 0;
      _monthlyExpense.value = 0;
      _recentTransactions.clear();
      _budgetUsage.clear();
    } finally {
      _isLoading.value = false;
    }
  }
}

/// Snapshot of one category's budget vs actual spend for the strip on Home.
class CategoryBudgetUsage {
  final String category;
  final double spent;
  final double budgeted;

  const CategoryBudgetUsage({
    required this.category,
    required this.spent,
    required this.budgeted,
  });

  double get percentUsed =>
      budgeted == 0 ? 0 : (spent / budgeted).clamp(0.0, 2.0);
  bool get isOver => spent > budgeted && budgeted > 0;
  bool get isWarning => percentUsed >= 0.8 && !isOver;
}
