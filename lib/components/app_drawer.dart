import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/utils.dart';

class AppDrawer extends StatelessWidget {

   String role;
   String nome;
   AppDrawer(this.role,this.nome);

  @override
  Widget build(BuildContext context) {

    print(" nome $nome");
    print(" role $role");
    return Drawer(
      child: Column(
        children: [
          AppBar(
          //  title: Obx(() => Text(" Bem vindo, $nome}!!")),
            title:  Text(" Bem vindo, $nome!!"),
            automaticallyImplyLeading: false,
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Get.toNamed(Routes.INITIAL);
              Navigator.pop(context);
            },
          ),
          Divider(),

          role==Role.admin
              ?ListTile(
            leading: Icon(Icons.store),
            title: Text('Minha Loja'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.STORES);

            },
          )
          :ListTile(
            leading: Icon(Icons.person),
            title: Text('Minha Conta'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.USERS);

            },
          ),
          Divider(),

          role==Role.admin?ListTile(
            leading: Icon(Icons.person),
            title: Text('Gerenciar Clientes'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.CARDSLOJA);

            },
          ):Container(),
          role==Role.admin? Divider():Container(),

          role==Role.cliente?ListTile(
            leading: Icon(Icons.shopping_basket_rounded),
            title: Text('Meus Resgates'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.RESGATES);

            },
          ):Container(),
          role==Role.cliente? Divider():Container(),

          role==Role.cliente?ListTile(
            leading: Icon(Icons.store),
            title: Text('Lojas'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.ALLSTORES);

            },
          ):Container(),
          role==Role.cliente?Divider():Container(),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();

              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_OR_HOME,
              );
            },
          ),
        ],
      ),
    );
  }
}
