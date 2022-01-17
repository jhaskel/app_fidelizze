import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:shop/core/controllers/card_list_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/models/cardList.dart';
import 'package:shop/core/models/stores.dart';

import 'package:shop/pages/cardList/cards_cliente_loja_page.dart';

import 'package:shop/providers/auth.dart';

class CardsLojaPage extends StatefulWidget {

  @override
  State<CardsLojaPage> createState() => _CardsLojaPageState();
}

class _CardsLojaPageState extends State<CardsLojaPage> {
  List<dynamic> listCardList =[];
  List<CardList> listCardLista =[];
  List<dynamic> listStores =[];
  CardListController controller =  Get.put(CardListController());
  List<int> quantList = [];
  List<String> clientes = [];
  List<String> nomeClientes = [];
  int? inicial;
  List<ListC> listd = [];
  List<int> estrelas =[];


  @override
  Widget build(BuildContext context) {
    controller.loadCardLists();
    return inicio(context);
  }

  GetX<CardListController> inicio(BuildContext context) {

    var user=Provider.of<Auth>(context);
    print("AGU ${user.email}");
    return GetX<CardListController>(
        builder: (_) {
          return Scaffold(

            appBar: AppBar(
              title: Text("Usuários com Adesivos"),

            ),
            body: _.isLoading.value?
            Center(child: CircularProgressIndicator()):
            _body(_,user),
          );
        }
    );
  }

  _body(CardListController _, Auth user) {
     listd.clear();
     estrelas.clear();
    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else if(_.scardListList.length==0){
      return Center(child: Text("Nenhum Serviço cadastrado!"),);
    }
    else

      listCardList.clear();
      listCardList = _.scardListList.value;
      for (var g in listCardList){
        print("FGH ${g.cliente}");
        listCardLista.add(CardList(id: g.id, store: g.store, code: g.code, createdAt: g.createdAt, cliente: g.cliente,nomeCliente: g.nomeCliente));
      }
      print("NEW LIS $listCardLista");


    var f = listCardLista.map((e) => e.cliente).toList().toSet();

    for(var x in f){
      var z = listCardLista.where((e) => e.cliente==x).toList();
     print("GGGG${z.length}");

      listd.add(ListC(z.first.nomeCliente.toString(),z.length));
      if(!estrelas.contains(z.length)){
        estrelas.add(z.length);
      }
    }





    listd.sort((a, b) => b.quant.compareTo(a.quant));
    estrelas.sort((a, b) => b.compareTo(a));
    print("ESTREAS $estrelas");

    if (inicial != null) {
      print("entrou $inicial");
      listd =
          listd.where((e) => e.quant == inicial).toList();
    }
print("NMN $listd");


    return  Column(
      children: [
      Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: estrelas.length,
          itemBuilder: (context,index){

            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    inicial =estrelas[index];
                  });

                },
                  child: Chip(
                    backgroundColor: inicial==estrelas[index]?Colors.blue:Colors.black26,
                      label: Text(estrelas[index].toString(),style: TextStyle(color: Colors.white),)

                  )
              ),
            );
          }
        ),

      ),
       Expanded(
         child: Container(
            child:  ListView.builder(
                itemCount: listd.length,
                itemBuilder: (context,index){
                  ListC c = listd[index];
                  print("BBB ${c.quant}");
                  print("BBBB ${inicial}");

                    return ListTile(
                      title: Text(c.nome),
                      trailing: Text(c.quant.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 30)),

                    );

                  return Container();


                }
            )
      ),
       ),
      ],
    );

  }
}
class ListC{
  String nome;
  int quant;

  ListC(this.nome, this.quant);
}
