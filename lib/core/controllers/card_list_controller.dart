

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/cardList.dart';
import 'package:shop/data/store.dart';

class CardListController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList scardListList = [].obs;
  RxList cardDeletar = [].obs;
  var _userName = "".obs;
  var _txtButton = "Second ".obs;
  var isErro = false.obs;
  List<dynamic> listaOriginal = [];

  get userName => _userName.value;
  set userName(value) => _userName.value = value;

  get txtButton => _txtButton.value;
  set txtButton(value) => _txtButton.value = value;
  var user;
  String? idUser;

  @override
  void onInit() {

   // loadCardLists();
    super.onInit();
  }



  Future<void> loadCardLists() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      scardListList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_CARDLIST}/$idUser.json'),
      );
      print('${AppConstants.BASE_URL_CARDLIST}/$idUser.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((scardListId, scardListData) {


        scardListList.add(
          CardList(
            id: scardListId,
            cliente: scardListData['cliente'],
            createdAt: scardListData['createdAt'],
            store: scardListData['store'],
            code: scardListData['code'],
            nomeCliente: scardListData['nomeCliente'],

          ),
        );


        addList1(scardListList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }

  Future<void> loadCardListCliente(String idLoja) async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      scardListList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_CARDLIST}/$idLoja.json'),
      );
      print('${AppConstants.BASE_URL_CARDLIST}/$idLoja.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((scardListId, scardListData) {
        scardListList.add(
          CardList(
            id: scardListId,
            cliente: scardListData['cliente'],
            createdAt: scardListData['createdAt'],
            store: scardListData['store'],
            code: scardListData['code'],
            nomeCliente: scardListData['nomeCliente'],
          ),
        );
        print("scardList ${scardListList.first.id}");
        addList1(scardListList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }
  Future<void> loadCardDeletar(String cliente,String loja) async {
    await loadCardLists();
    try{
      isLoading(true);
      cardDeletar.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_CARDLIST}/$loja.json'),
      );
      print('${AppConstants.BASE_URL_CARDLIST}/$loja.json');
      print("resposta20 ${response.body}");
      print("resposta89 ${scardListList.value}");
      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      print("data ${data}");
      data.forEach((scardListId, scardListData) {
        cardDeletar.add(
          CardList(
            id: scardListId,
            cliente: scardListData['cliente'],
            createdAt: scardListData['createdAt'],
            store: scardListData['store'],
            code: scardListData['code'],
            nomeCliente: scardListData['nomeCliente'],
          ),
        );

     //   addList1(scardListList);
      });
      print("HHHH ${cardDeletar.value}");
      var f = cardDeletar.where((e) => e.cliente==cliente).toList();
      var t = f.map((e) => e.id);
      for(var x in t){
        print("removendo $x....");
        removeCard(x);
      }
      print("deletar ${t}");


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }


  addList1(RxList scardListList) {
    listaOriginal = scardListList;
    itens = scardListList.length;
    print("SEr lsit ${scardListList}");

    update();
  }

  Future<void> saveCardList(Map<String, Object> data, bool add ){

    bool hasId = data['id'] != null;
    final scardList = CardList(
      id:  data['id'] as String ,
      cliente: data['cliente'] as String,
      createdAt: data['createdAt'] as String,
      store: data['store'] as String,
      code: data['code'] as String,
      nomeCliente: data['nomeCliente'] as String,

    );

    if (hasId && !add) {
      return updateCardList(scardList);
    } else {
      return addCardList(scardList);
    }
  }

  Future<void> addCardList(CardList scardList) async {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_CARDLIST}/${scardList.store}.json'),
      body: jsonEncode(
        {
          "id": scardList.id,
          "cliente": scardList.cliente,
          "createdAt": scardList.createdAt,
          "code": scardList.code,
          "store": scardList.store,
          "nomeCliente": scardList.nomeCliente,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    scardListList.add(CardList(
      id: id,
      cliente: scardList.cliente,
      createdAt: scardList.createdAt,
      code: scardList.code,
      store: scardList.store,
      nomeCliente: scardList.nomeCliente,
    ));
    print("Service List $scardListList");

    update();
  }

  Future<void> updateCardList(CardList scardList) async {
    int index = scardListList.indexWhere((p) => p.id == scardList.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_CARDLIST}/$idUser/${scardList.id}.json',
        ),
        body: jsonEncode(
          {
            "cliente": scardList.cliente,
            "createdAt": scardList.createdAt,
            "code": scardList.code,
            "store": scardList.store,
            "nomeCliente": scardList.nomeCliente,
          },
        ),
      );

      scardListList[index] = scardList;
      update();
    }
  }



  addList(List<CardList> result) {
    scardListList.clear();
    scardListList.assignAll(result);
    listaOriginal = result;
    itens = scardListList.length;
    print("5x $scardListList");

    print("oringal $listaOriginal");
    update();
  }



  add(CardList scardList) {
    print("city $scardList");
    scardListList.removeWhere((x) => x.id == scardList.id);
    scardListList.add(scardList);
  }

  adds(List x) {
    print("VVVV $x");
    scardListList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      scardListList.add(k);

    }
  }




  addErro() {
    isErro(true);
  }




  Future<void> removeCardList(CardList scardList) async {
    int index = scardListList.indexWhere((p) => p.id == scardList.id);
    print("PP0 $index");
    print("PP00 ${scardList.id}");
    if (index >= 0) {
      final scardList = scardListList[index];
      scardListList.remove(scardList);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/scardList/$idUser/${scardList.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_CARDLIST}/${scardList.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        scardListList.insert(index, scardList);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
  Future<void> removeCard(String cardList) async {



      final response = await http.delete(
        Uri.parse(
          '${AppConstants.BASE_URL_CARDLIST}/$idUser/$cardList.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_CARDLIST}/$idUser/${cardList}.json");
      print("PP2 ${response.statusCode}");



  }

}
