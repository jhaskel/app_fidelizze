


import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/pages/cardList/cards_cliente_loja_page.dart';
import 'package:shop/pages/cards/barcode.dart';
import 'package:shop/pages/cardList/cards_loja_page.dart';
import 'package:shop/pages/cards/barcode2.dart';
import 'package:shop/pages/cards/cards_page.dart';
import 'package:shop/pages/cards/cards_page_detalhe.dart';
import 'package:shop/pages/home/auth_or_home_page.dart';
import 'package:shop/pages/login/auth_page.dart';
import 'package:shop/pages/product/product_page.dart';
import 'package:shop/pages/product/product_add.dart';
import 'package:shop/pages/resgates/resgates_page.dart';
import 'package:shop/pages/services/services_add.dart';
import 'package:shop/pages/services/services_page.dart';
import 'package:shop/pages/stores/all_stores_detalhe_page.dart';
import 'package:shop/pages/stores/all_stores_page.dart';
import 'package:shop/pages/stores/stores_add.dart';
import 'package:shop/pages/stores/stores_page.dart';
import 'package:shop/pages/users/users_add.dart';
import 'package:shop/pages/users/users_all_page.dart';
import 'package:shop/pages/users/users_page.dart';
import 'package:shop/utils/camera.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL,page: () => AuthOrHomePage(),),
    GetPage(name: Routes.PRODUCT_ADD, page: () => ProductAdd()),
    GetPage(name: Routes.PRODUCT, page: () => ProductPage()),
    GetPage(name: Routes.LOGIN, page: () => AuthPage()),
    GetPage(name: Routes.USERS, page: () => UsersPage()),
    GetPage(name: Routes.USERS_ADD, page: () => UsersAdd()),
    GetPage(name: Routes.SERVICES, page: () => ServicesPage(role: '',nome: '',)),
    GetPage(name: Routes.SERVICES_ADD, page: () => ServicesAdd()),
    GetPage(name: Routes.STORES, page: () => StoresPage()),
    GetPage(name: Routes.ALLSTORES, page: () => AllStoresPage()),
    GetPage(name: Routes.ALLSTOREDETALHE, page: () => AllStoresDetalhePage()),
    GetPage(name: Routes.AllUSERS, page: () => UsersAllPage()),
    GetPage(name: Routes.STORES_ADD, page: () => StoresAdd()),
    GetPage(name: Routes.CARDS, page: () => CardsPage(role: '',nome: '')),

    GetPage(name: Routes.CARDSLOJA, page: () => CardsLojaPage()),
    GetPage(name: Routes.BARCODE, page: () => BarcodePage()),
    GetPage(name: Routes.BARCODE2, page: () => Barcode2Page()),

    GetPage(name: Routes.RESGATES, page: () => ResgatesPage()),
  ];
}
