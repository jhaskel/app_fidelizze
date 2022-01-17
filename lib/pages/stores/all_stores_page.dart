import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class AllStoresPage extends StatelessWidget {
  String titli = 'Getx Example';
  List<dynamic> listStores =[];
  StoresController controller =  Get.put(StoresController());
 // UsersController controllerUser =  Get.put(UsersController());
  late Stores c;
  @override
  Widget build(BuildContext context) {
   controller.loadAllStores();
    return inicio(context);
  }

  GetX<StoresController> inicio(BuildContext context) {

    return GetX<StoresController>(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Lojas Conveniadas"),
              centerTitle: true,
            ),
            body: _.isLoading.value?
            Center(child: CircularProgressIndicator()):

            _body(_,context),
          );
        }
    );
  }

  _body(StoresController _,  BuildContext context) {
    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else if(_.allstoresList.length==0){
      return Center(child: Text("Nenhuma Loja cadastrada"),);
    }
    else
      listStores = _.allstoresList.value;
    print("lk $listStores");
     c = listStores.first;
    return ListView.builder(
        itemCount: listStores.length,
        itemBuilder: (context, index) {
        Stores c = listStores[index];
       return ListTile(
         onTap: (){
           Get.toNamed(Routes.ALLSTOREDETALHE, arguments: c);
         },
         leading:  CircleAvatar(
           radius: 30,
             child: Image.network(
               c.logo,
               width: 50,
             )),
         title:  Text(c.nome),
         subtitle:   Container(
           child: Align(
             alignment: Alignment.bottomLeft,
             child: IconButton(
               onPressed: (){
                 launch(
                     "https://www.google.com/maps/search/?api=1&query=${c.nome},${c.address}" //lauch vem do plugin
                 );
               },
               icon: Icon(Icons.map)

             ),
           ),
         ),
         trailing: getOpen(c.isopen),
       );



        });
  }

  Widget getOpen(bool isopen) {
    if (isopen) {
      return Text(
        "Aberto",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else
      return Text(
        "Fechado",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
  }
}
