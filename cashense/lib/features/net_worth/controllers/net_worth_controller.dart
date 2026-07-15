import 'package:get/get.dart';

/// State powering the Net Worth dashboard — the app's marketing wedge and
/// hero surface (see PROJECT.md §2, D2/D3).
///
/// Phase A ships the empty-state scaffold: the asset and liability
/// repositories don't exist yet (Phase B / Phase C). Every figure is `0`
/// until those land, at which point [_load] recomputes from repository
/// streams and `netWorth` becomes Σ asset current values − Σ liability
/// balances.
class NetWorthController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxDouble _totalAssets = 0.0.obs;
  final RxDouble _totalLiabilities = 0.0.obs;

  bool get isLoading => _isLoading.value;
  double get totalAssets => _totalAssets.value;
  double get totalLiabilities => _totalLiabilities.value;

  /// Σ asset current values − Σ liability balances. The hero number.
  double get netWorth => _totalAssets.value - _totalLiabilities.value;

  /// No assets and no liabilities recorded yet — drives the empty state.
  bool get isEmpty => _totalAssets.value == 0 && _totalLiabilities.value == 0;

  RxBool get isLoadingObs => _isLoading;
  RxDouble get totalAssetsObs => _totalAssets;
  RxDouble get totalLiabilitiesObs => _totalLiabilities;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> refreshNetWorth() => _load();

  Future<void> _load() async {
    _isLoading.value = true;
    try {
      // Phase A empty state — asset/liability repositories arrive in
      // Phase B / Phase C. Replace these stubs with real reads then and
      // recompute on their streams.
      _totalAssets.value = 0;
      _totalLiabilities.value = 0;
    } finally {
      _isLoading.value = false;
    }
  }
}
