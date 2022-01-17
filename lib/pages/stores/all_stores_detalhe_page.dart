import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';

class AllStoresDetalhePage extends StatefulWidget {
  @override
  State<AllStoresDetalhePage> createState() => _AllStoresDetalhePageState();
}

class _AllStoresDetalhePageState extends State<AllStoresDetalhePage> {



  late String logo;
  late String nome;
  late String address;
  late int adesivos;
  late String description;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final store = arg as Stores;
        nome = store.nome;
        address = store.address;
        description= store.description!;
        logo = store.logo;
        adesivos= store.adesivos;
      }

  }
  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<StoresController> inicio(BuildContext context) {

    return GetX<StoresController>(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text(nome),
              centerTitle: true,

            ),
            body: _.isLoading.value?
            Center(child: CircularProgressIndicator()):

            _body(context),
          );
        }
    );
  }

  _body(BuildContext context) {


    return Container(
      height: MediaQuery.of(context).size.width,

      child: Center(
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              child: Image.network(logo),
            ),
            Text(nome,style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text(address),
            SizedBox(height: 10,),
            Text(description.toString(),style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.bold),),



          ],
        ),
      ),
    );
  }
}
