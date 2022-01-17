import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/models/cards.dart';
import 'package:shop/core/models/stores.dart';

import 'package:shop/providers/auth.dart';

class CardsPageDetalhe extends StatefulWidget {
  Stores stor;
  CardsPageDetalhe({required this.stor});

  @override
  State<CardsPageDetalhe> createState() => _CardsPageDetalheState();
}

class _CardsPageDetalheState extends State<CardsPageDetalhe> {
  List<dynamic> listCards = [];
  Stores get stores=>widget.stor;
  late int adesivos;
  String? store;
  int colunas = 1;
  CardsController controller = Get.put(CardsController());

  @override
  void initState() {
    super.initState();
    adesivos = widget.stor.adesivos;
    store = widget.stor.idd;

  }

  @override
  Widget build(BuildContext context) {
    print("Haskel");
    print('ARGS ${stores.id}');
    return inicio(context);
  }

  GetX<CardsController> inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);
    controller.loadCar(store!);
    return GetX<CardsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(

          title: Text(stores.nome),
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
    } else
      listCards = _.cardsList.value;
    //   print("lk $listCards");
    var quant = _.cardsList.length;

    if (adesivos <= 5) {
      colunas = adesivos;
    }
    if (adesivos == 6) {
      colunas = 3;
    }
    if (adesivos > 6 && adesivos < 10) {
      colunas = 3;
    }
    if (adesivos >= 10) {
      colunas = 5;
    }
    print("Colunas $colunas");
    print("Adesivsos $adesivos");

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Flexible(
              fit: FlexFit.tight,
              flex: 10,
              child: Container(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: colunas,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: adesivos,
                    itemBuilder: (context, index) {
                      var ade = stores.logo;
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
                      /*   Cards c = listCards[index];
                return ListTile(
                  onTap: (){
                    gerarQrCode(context,c,user);
                  },

                  title: Text(c.code),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        _.removeCards(c);
                      },icon: Icon(Icons.restore_from_trash),),
                      IconButton(onPressed: (){
                        Get.toNamed(Routes.SERVICES_ADD,arguments: c);
                      },icon: Icon(Icons.edit),)
                    ],

                  ),
                );*/
                    }),
              )),
          Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: adesivos <= quant
                    ? MaterialButton(
                        color: Colors.green,
                        onPressed: () {
                          showResgatar(context, user);
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
    );
  }

  gerarQrCode(BuildContext context, Cards c, Auth user) {
    double largura = 300;

    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
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

  getColunas(int adesivos) {
    if (adesivos < 5) {
      return 5;
    }
    if (adesivos == 6) {
      return 3;
    }
    if (adesivos > 6 && adesivos < 10) {
      return 3;
    }
    if (adesivos > 10) {
      return 5;
    }
  }

  void showResgatar(BuildContext context, Auth user) {
    double largura = 300;
    var code = "${stores.id}.${user.idUser}";

    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
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
