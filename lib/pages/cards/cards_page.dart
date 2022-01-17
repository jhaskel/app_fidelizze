import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/controllers/resgates_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/models/cards.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/routes/app_routes.dart';


import 'package:shop/providers/auth.dart';

class CardsPage extends StatefulWidget {
  String role;
  String nome;
  CardsPage({required this.role, required this.nome});
  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List<dynamic> listCards = [];
  List<dynamic> listStores = [];
  Stores? stores;
  int? adesivos;
  int colunas = 1;
  CardsController controller = Get.put(CardsController());
  StoresController controllerStore = Get.put(StoresController());
  ResgatesController controllerResgate = Get.put(ResgatesController());

  @override
  Widget build(BuildContext context) {
    controller.loadCards();
      controllerStore.loadStoress();
    return inicio(context);
  }

  GetX<CardsController> inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);
    print("AGU ${user.email}");
    return GetX<CardsController>(builder: (_) {
      return Scaffold(
        drawer: AppDrawer(widget.role, widget.nome),
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

  _body(CardsController _, Auth user) {
    if (_.isErro.value) {
      return Center(
        child: Text("Ocorreu um erro insesperado!"),
      );
    } else if (_.cardsList.length == 0) {
      return Center(
        child: Text("Nenhum Cartão Ativo!",style: TextStyle(fontSize: 20,color: Colors.indigo),),

      );
    } else
      listCards = _.cardsList.value;

    List<String> jk = [];
    var k = listCards.map((e) => e.store).toList().toSet();
    for (var f in k) {
      jk.add(f);
    }
    print('KK${k}');
    return GetX<StoresController>(builder: (sto) {
      if (sto.isErro.value) {
        return Center(
          child: Text("Ocorreu um erro insesperado!"),
        );
      } else if (sto.storesList.length == 0) {
        return Center(
          child: Text("Nenhum Cartão Ativo!",style: TextStyle(fontSize: 20,color: Colors.indigo),),
        );
      } else
        listStores = sto.storesList.value;
      print('StoresTT ${listStores}');
      return Container(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .9,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: jk.length,
              itemBuilder: (context, index) {
                controllerStore.loadStore(jk[index]);
                return GetX<StoresController>(builder: (st) {
                  if (st.isErro.value) {
                    return Center(
                      child: Text("Ocorreu um erro insesperado!"),
                    );
                  } else if (st.storeList.length == 0) {
                    return Center(
                      child: Text("Nenhuma Loja cadastrada"),
                    );
                  } else
                    listStores = st.storeList.value;
                  print('Stores ${listStores}');
                  Stores c = listStores[index];
                  var g = listCards.where((e) => e.store==c.id);
                  var quant = 0;
                  quant =g.length;
                  Cards card = g.first;
                  print("QT $quant");
                  print("QT ${card.code}");
                  return InkWell(
                    onTap: () {
                      showCard(context,c,quant,user);
                     /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CardsPageDetalhe(
                                    stor: c,
                                  )));*/
                    },
                    child: Column(
                      children: [
                        Container(
                            height: 150,
                            child: Image.network(
                              c.logo,
                              width: 150,
                            )),
                        Text("${c.nome} $quant"),
                        getOpen(c.isopen),
                      ],
                    ),
                  );
                });
              }));
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

  showCard(BuildContext context, Stores c, int quant, Auth user, ) {
    adesivos = c.adesivos;
    if (adesivos! <= 5) {
      colunas = adesivos!;
    }
    if (adesivos == 6) {
      colunas = 3;
    }
    if (adesivos! > 6 && adesivos! < 10) {
      colunas = 3;
    }
    if (adesivos! >= 10) {
      colunas = 5;
    }
   
    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {

        Navigator.of(context).pop();
     //   gerarQrCode(context);

      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "$quant/$adesivos",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 10,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: adesivos,
                    itemBuilder: (context, index) {
                      var ade = c.logo;
                      var t = index + 1;
                      return Container(
                          child: quant >= t
                              ? Image.network(
                            ade,
                            width: 75,
                          )
                              : Icon(
                            Icons.star_border,
                            size: 75,
                            color: Colors.black26,
                          ));

                    }),
              ),
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: adesivos! <= quant
                    ? MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    showResgatar(context, user,c);
                  },
                  child: Text('Resgatar Brinde'),
                )
                    : MaterialButton(
                  color: Colors.black26,
                  onPressed: () {},
                  child: Text('Você precisa de $adesivos adesivos'),
                ),
              )),
        ],

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

  void showResgatar(BuildContext context, Auth user, Stores c) {

    var code = "${c.id}.${user.userId}";

    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        controller.loadCards();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Código",
        style: Theme.of(context).textTheme.headline3,
      ),
      content: Container(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: code,
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


}
