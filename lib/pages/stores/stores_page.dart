import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';

class StoresPage extends StatelessWidget {
  String titli = 'Getx Example';
  List<dynamic> listStores =[];
  StoresController controller =  Get.put(StoresController());
  UsersController controllerUser =  Get.put(UsersController());
  late Stores c;
  int quant =0;
  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<StoresController> inicio(BuildContext context) {
    var user=Provider.of<Auth>(context);
    print("AGU ${user.email}");
    return GetX<StoresController>(
        builder: (_) {

          return Scaffold(
            appBar: AppBar(
              title: Text("Minha Loja"),
              centerTitle: true,
              actions: [
                IconButton(onPressed: (){
                  Get.toNamed(Routes.STORES_ADD,arguments: c);
                }, icon: Icon(Icons.edit)),

              ],
            ),
            body: _.isLoading.value?
            Center(child: CircularProgressIndicator()):

            _body(_,user,context),
          );
        }
    );
  }
  _init(){

    return Scaffold(

      body: Center(child: MaterialButton(
        onPressed: () {
          Get.toNamed(Routes.STORES_ADD);
        },
        color: Colors.blue,
        child: Text("Nova Loja",style: TextStyle(color: Colors.white),),
      ))
    );

  }

  _body(StoresController _, Auth user, BuildContext context) {
    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else if(_.storesList.length==0){
      return _init();
    }
    else
      listStores = _.storesList.value;
    print("lk $listStores");
     c = listStores.first;
    return Container(
      height: MediaQuery.of(context).size.width,

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image.network(c.logo),
            ),
            Text(c.nome),
            SizedBox(height: 10,),
            Text(c.address),
            SizedBox(height: 10,),
            Text(c.adesivos.toString(),style: TextStyle(fontSize: 30,color: Colors.blue),),



          ],
        ),
      ),
    );
  }
}
