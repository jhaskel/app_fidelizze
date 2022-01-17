
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/product_controller.dart';
import 'package:shop/core/controllers/resgates_controller.dart';
import 'package:shop/core/controllers/services_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/pages/services/services_page.dart';
import 'package:shop/providers/auth.dart';

class AppDependencies {

  static Future<void> init() async {


    Get.lazyPut(() => UsersController());
    Get.lazyPut(() => StoresController());
    Get.lazyPut(() => ResgatesController());
    Get.lazyPut(() => ServicesController());
  }
}