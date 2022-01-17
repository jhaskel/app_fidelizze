
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/users.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';


class UsersPage extends StatelessWidget {

  String titli = 'Getx Example';
  List<dynamic> listUsers =[];
  TextEditingController _controllerNome = TextEditingController();
  UsersController controler =  Get.put(UsersController());

  @override
  Widget build(BuildContext context) {

    return inicio(context);

  }

  GetX<UsersController> inicio(BuildContext context) {


    return GetX<UsersController>(
      builder: (_) {
        return Scaffold(

          appBar: AppBar(
            title: Text("usuarios"),

          ),
          body: _.isLoading.value?
          Center(child: CircularProgressIndicator()):

          _body(_,context),
        );
      }
  );
  }

  _body(UsersController _, BuildContext context) {
    var user=Provider.of<Auth>(context);
    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else
      listUsers = _.usersList.value;
    print("lk $listUsers");

    return Container(
        child:  ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (context,index){
              Users c = listUsers[index];
              if(c.id!=user.userId){
                return Container();
              }else
              return ListTile(
                title: Text(c.nome),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    IconButton(onPressed: (){
                      Get.toNamed(Routes.USERS_ADD,arguments: c);
                    },icon: Icon(Icons.edit),)
                  ],

                ),
              );

            }
        )

    );
  }
}
