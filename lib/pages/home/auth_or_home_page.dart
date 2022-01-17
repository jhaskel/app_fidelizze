import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/pages/home/roteador_page.dart';
import 'package:shop/pages/product/product_page.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/pages/login/auth_page.dart';


class AuthOrHomePage extends StatefulWidget {
  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  UsersController controller = Get.put(UsersController());


  @override
  Widget build(BuildContext context) {

    Auth auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {

          return auth.isAuth
              ? RoteadorPage()
              : AuthPage();
        }
      },
    );
  }
}
