import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/controllers/resgates_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';

class StoresClientePage extends StatelessWidget {
  List<dynamic> listStores = [];
  StoresController controller = Get.put(StoresController());
  ResgatesController controllerResgate = Get.put(ResgatesController());
  UsersController controllerUser = Get.put(UsersController());
  CardsController controllerCards = Get.put(CardsController());
  List<dynamic> listCards = [];

  String role;
  String nome;
  StoresClientePage({required this.role, required this.nome});

  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<StoresController> inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);
    controllerResgate.resgatesList;
    controller.loadAllStores();
    print("AGU ${user.email}");
    return GetX<StoresController>(builder: (_) {
      return Scaffold(
        drawer: AppDrawer(role, nome),
        appBar: AppBar(
          title: Text("Cartão de Fidelidade"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.BARCODE);
                },
                icon: Icon(Icons.qr_code)),

            Container(
              child: InkWell(
                onTap: (){ Get.toNamed(Routes.RESGATES);},
                child: Obx(() =>controllerResgate.resgatesList!=null ?Padding(
                  padding: const EdgeInsets.only(top: 10,right: 10),
                  child: Text(controllerResgate.resgatesList.length.toString(),style: TextStyle(fontSize: 20),),
                ):Container())
                ,
              ),
            )

      ],
        ),
        body: _.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : _body(_, user),
      );
    });
  }

  _body(StoresController _, Auth user) {
    if (_.isErro.value) {
      return Center(
        child: Text("Ocorreu um erro insesperado!"),
      );
    } else if (_.storesListCliente.length == 0) {
      return Center(
        child: Text("Nenhuma Loja cadastrada"),
      );
    } else
      listStores = _.storesListCliente.value;
    print("lk $listStores");


    return Container(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: listStores.length,
            itemBuilder: (context, index) {
              Stores c = listStores[index];
              print("XX ${c.id}");

              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CARDS, arguments: c);
                },
                child: Column(
                  children: [
                    Container(
                        height: 150,
                        child: Image.network(
                          c.logo,
                          width: 150,
                        )),
                    Text(c.nome),
                    getOpen(c.isopen),
                  ],
                ),
              );
            }));
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
