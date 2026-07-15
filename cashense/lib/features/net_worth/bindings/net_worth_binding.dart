import 'package:get/get.dart';
import 'package:cashense/features/net_worth/controllers/net_worth_controller.dart';

class NetWorthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetWorthController>(() => NetWorthController(), fenix: true);
  }
}
