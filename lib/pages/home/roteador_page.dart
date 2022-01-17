import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/pages/cards/cards_page.dart';

import 'package:shop/pages/services/services_page.dart';
import 'package:shop/pages/stores/stores_cliente_page.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/utils/utils.dart';

class RoteadorPage extends StatefulWidget {
  @override
  State<RoteadorPage> createState() => _RoteadorPageState();
}

class _RoteadorPageState extends State<RoteadorPage> {
   String? role;
   String? nome;

  UsersController controller = Get.put(UsersController());

  List<dynamic> listUsers = [];


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Auth>(context);
    if (user != null) {
      controller.loadUser(user.userId);
      return GetX<UsersController>(builder: (_) {
        print('Role ${_.userRole}');
        role = _.userRole.toString();
        nome = _.userNome.toString();
        listUsers = _.userList.value;
        print('Role ${_.userRole}');
        if(role !=null){
          print('YY $role');
          print('YYY $nome');
          if (role == 'admin') {
            return ServicesPage(role:role!,nome:nome!);
          } else if(role == 'cliente'){
           // return StoresClientePage(role:role!,nome:nome!);
           return CardsPage(role:role!,nome:nome!);
          }else
            return Container();
        }
        return null!;


      });
    } else {
      return Container();
    }

  }
}
