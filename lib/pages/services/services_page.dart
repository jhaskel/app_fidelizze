import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/services_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';

class ServicesPage extends StatelessWidget {
  List<dynamic> listServices = [];
  List<dynamic> listStores = [];
  ServicesController controller = Get.put(ServicesController());
  StoresController controllerStore = Get.put(StoresController());
  String role;
  String nome;

  ServicesPage({required this.role, required this.nome});
  String? nomeLoja;
  Stores? store;

  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<ServicesController> inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);

    return GetX<ServicesController>(builder: (_) {
      return Scaffold(
        drawer: AppDrawer(role, nome),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(
              Routes.SERVICES_ADD,
            );
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("Meus Serviços"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.BARCODE2, arguments: store);
                },
                icon: Icon(Icons.qr_code)),
          ],
        ),
        body: _.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : _body(_, user),
      );
    });
  }

  _body(ServicesController _, Auth user) {
    if (_.isErro.value) {
      return Center(
        child: Text("Ocorreu um erro insesperado!"),
      );
    } else if (_.servicesList.length == 0) {
      return Center(
        child: Text("Nenhum Serviço cadastrado!"),
      );
    } else{
      listServices = _.servicesList.value;
      print("lk $listServices");
      var isOpen = false;

      return GetX<StoresController>(builder: (sto) {
        if (_.isErro.value) {
          return Center(
            child: Text("Ocorreu um erro insesperado!"),
          );
        } else if (_.servicesList.length == 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          listStores = sto.storesList.value;
          isOpen = listStores.first.isopen;
          nomeLoja = listStores.first.nome;
          store = listStores.first;
          print("nome LO $nomeLoja");

          return Container(
              child: ListView.builder(
                  itemCount: listServices.length,
                  itemBuilder: (context, index) {
                    Services c = listServices[index];
                    return ListTile(
                      onTap: () {
                        gerarQrCode(context, c, user);
                      },
                      leading: Icon(
                        Icons.check_circle,
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                      title: Text(c.nome),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.AllUSERS, arguments: c);
                            },
                            icon: Icon(
                              Icons.star_border,
                              color: Colors.amber,
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        Get.toNamed(Routes.SERVICES_ADD,
                                            arguments: c);
                                      },
                                      child: Text("Editar")),
                                ),
                              ),
                              PopupMenuItem(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        showDeletar(context, c, _);
                                      },
                                      child: Text("Excluir")),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }));
        }
      });
    }

  }

  gerarQrCode(BuildContext context, Services c, Auth user) {
    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        c.nome,
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: c.code,
              padding: EdgeInsets.all(2),
              gapless: true,
              size: 200,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
        ),
      ),
      actions: [
        cancelaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeletar(BuildContext context, Services c, ServicesController _) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      child: Text("Excluir"),
      onPressed: () {
        _.removeServices(c);
        Navigator.of(context).pop();
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Tem certeza quer Deletar?",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: Text(
              c.nome,
            ),
          ),
        ),
      ),
      actions: [cancelaButton, okButton],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
