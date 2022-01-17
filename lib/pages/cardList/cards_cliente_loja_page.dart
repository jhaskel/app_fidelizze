import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/models/cards.dart';
import 'package:shop/core/models/stores.dart';

import 'package:shop/providers/auth.dart';

class CardsLojistaPage extends StatefulWidget {
  Stores stores;
  String cliente;
  CardsLojistaPage(this.stores,this.cliente);

  @override
  State<CardsLojistaPage> createState() => _CardsLojistaPageState();
}

class _CardsLojistaPageState extends State<CardsLojistaPage> {
  List<dynamic> listCards = [];

  int colunas =1;
  CardsController controller = Get.put(CardsController());

  @override
  Widget build(BuildContext context) {

    return inicio(context);
  }

   inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);
    controller.loadCardLojista(loja: widget.stores.id,cliente: widget.cliente);
    print("AGU ${user.email}");


    return GetX<CardsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.stores.nome),
        ),
        body: _.isLoading.value
            ? Center(child: CircularProgressIndicator())
            :Center(child: Text("Vai continuar"),)
           // : _body(_, user),
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


    if(widget.stores.adesivos <= 5){
      colunas = widget.stores.adesivos;
    }
    if(widget.stores.adesivos ==6){
      colunas = 3;
    }
    if(widget.stores.adesivos >6&& widget.stores.adesivos <10){
      colunas =  3;
    }
    if(widget.stores.adesivos >=10){
      colunas =  5;
    }
    print("Colunas $colunas");


    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(height: 10,),
        Container(
          height: 500,
          child: GridView.builder(
              gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colunas,
                childAspectRatio: 1,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2, ),

              itemCount: widget.stores.adesivos,
              itemBuilder: (context, index) {
                var ade = widget.stores.logo;
                var t = index+1;
                return Container(
                    child:  quant >=t?Image.network(
                      ade,
                      width: 75,
                    ):Icon(Icons.star_border,size: 75,color: Colors.black26,)
                );
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
        ),
        Container(
          height: 50,
          child: widget.stores.adesivos<=quant?MaterialButton(
            color: Colors.green,
            onPressed: (){

            },
            child: Text('Resgatar Brinde'),
          ):MaterialButton(
            color: Colors.black26,
            onPressed: (){

            },
            child: Text('Você precisa de ${widget.stores.adesivos} adesivos'),
          ),
        ),
        SizedBox(height: 50,)

      ],

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
    if(adesivos<5){
      return 5;
    }
    if(adesivos ==6){
      return 3;
    }
    if(adesivos >6&& adesivos <10){
      return 3;
    }
    if(adesivos>10){
      return 5;
    }
  }
}
