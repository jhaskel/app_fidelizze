

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/resgates.dart';
import 'package:shop/data/store.dart';

class ResgatesController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList resgatesList = [].obs;
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
    loadResgates();
    super.onInit();
  }

  Future<void> loadResgates() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      resgatesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_RESGATES}/$idUser.json'),
      );
      print('${AppConstants.BASE_URL_RESGATES}/$idUser.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((servicesId, servicesData) {
        resgatesList.add(
          Resgates(
            id: servicesId,
            cliente: servicesData['cliente'],
            store: servicesData['store'],
            ano: servicesData['ano'],
            createdAt: servicesData['createdAt'],
            nomeLoja: servicesData['nomeLoja'],
          ),
        );
        print("services ${resgatesList.first.id}");
        addList1(resgatesList);
      });

    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }

  Future<void> loadResgatesCliente(String idLoja) async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      resgatesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_RESGATES}/$idLoja.json'),
      );
      print('${AppConstants.BASE_URL_RESGATES}/$idLoja.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((resgatesId, resgatesData) {
        resgatesList.add(
          Resgates(
            id: resgatesId,
            cliente: resgatesData['cliente'],
            store: resgatesData['store'],
            ano: resgatesData['ano'],
            createdAt: resgatesData['createdAt'],
            nomeLoja: resgatesData['nomeLoja'],
          ),
        );
        print("resgates ${resgatesList.first.id}");
        addList1(resgatesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }


  addList1(RxList resgatesList) {
    listaOriginal = resgatesList;
    itens = resgatesList.length;
    print("SEr lsit ${resgatesList}");

  update();
  }

  Future<void> saveResgates(Map<String, Object> data) {

    final resgates = Resgates(
      id: data['id'] as String ,
      cliente: data['cliente'] as String,
      store: data['store'] as String,
      ano: data['ano'] as String,
      createdAt: data['createdAt'] as String,
      nomeLoja: data['nomeLoja'] as String,

    );
      return addResgates(resgates);

  }

  Future<void> addResgates(Resgates resgates) async {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_RESGATES}/${resgates.cliente}.json'),
      body: jsonEncode(
        {
          "cliente": resgates.cliente,
          "ano": resgates.ano,
          "store": resgates.store,
          "createdAt": resgates.createdAt,
          "nomeLoja": resgates.nomeLoja,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    resgatesList.add(Resgates(
      id: id,
      cliente: resgates.cliente,
      ano: resgates.ano,
      store: resgates.store,
      createdAt: resgates.createdAt,
      nomeLoja: resgates.nomeLoja,
    ));
    print("Service List $resgatesList");

    update();
  }

  Future<void> updateResgates(Resgates resgates) async {
    int index = resgatesList.indexWhere((p) => p.id == resgates.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_RESGATES}/$idUser/${resgates.id}.json',
        ),
        body: jsonEncode(
          {
            "cliente": resgates.cliente,
            "ano": resgates.ano,
            "store": resgates.store,
            "createdAt": resgates.createdAt,
            "nomeLoja": resgates.nomeLoja,
          },
        ),
      );

      resgatesList[index] = resgates;
      update();
    }
  }



  addList(List<Resgates> result) {
    resgatesList.clear();
    resgatesList.assignAll(result);
    listaOriginal = result;
    itens = resgatesList.length;
    print("5x $resgatesList");


    print("oringal $listaOriginal");
    update();
  }



  add(Resgates resgates) {
    print("city $resgates");
    resgatesList.removeWhere((x) => x.id == resgates.id);
    resgatesList.add(resgates);
    increase(resgates);
  }

  adds(List x) {
    print("VVVV $x");
    resgatesList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      resgatesList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = resgatesList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    resgatesList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Resgates resgates) {
    itens = 0;
    resgatesList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    resgatesList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    resgatesList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = resgatesList[1].nome;
  }

  remove(Resgates item) {
    print("INTES1 $itens");
    resgatesList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeResgates(Resgates resgates) async {
    int index = resgatesList.indexWhere((p) => p.id == resgates.id);
   print("PP0 $index");
   print("PP00 ${resgates.id}");
    if (index >= 0) {
      final resgates = resgatesList[index];
      resgatesList.remove(resgates);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/resgates/$idUser/${resgates.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_RESGATES}/${resgates.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        resgatesList.insert(index, resgates);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
