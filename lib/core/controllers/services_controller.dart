

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/data/store.dart';

class ServicesController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList servicesList = [].obs;
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

   loadServicess();
    super.onInit();
  }



  Future<void> loadServicess() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      servicesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_SERVICES}/$idUser.json'),
      );
      print('${AppConstants.BASE_URL_SERVICES}/$idUser.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((servicesId, servicesData) {
        servicesList.add(
          Services(
            id: servicesId,
            nome: servicesData['nome'],
            store: servicesData['store'],
            code: servicesData['code'],
          ),
        );
        print("services ${servicesList.first.id}");
        addList1(servicesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }

  Future<void> loadServicesCliente(String idLoja) async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      servicesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_SERVICES}/$idLoja.json'),
      );
      print('${AppConstants.BASE_URL_SERVICES}/$idLoja.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((servicesId, servicesData) {
        servicesList.add(
          Services(
            id: servicesId,
            nome: servicesData['nome'],
            store: servicesData['store'],
            code: servicesData['code'],
          ),
        );
        print("services ${servicesList.first.id}");
        addList1(servicesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }


  addList1(RxList servicesList) {
    listaOriginal = servicesList;
    itens = servicesList.length;
    print("SEr lsit ${servicesList}");

  update();
  }

  Future<void> saveServices(Map<String, Object> data) {
    print("aki");
    bool hasId = data['id'] != null;

    final services = Services(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      nome: data['nome'] as String,
      store: data['store'] as String,
      code: data['code'] as String,

    );

    if (hasId) {
      return updateServices(services);
    } else {
      return addServices(services);
    }
  }

  Future<void> addServices(Services services) async {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_SERVICES}/$idUser.json'),
      body: jsonEncode(
        {
          "nome": services.nome,
          "code": services.code,
          "store": idUser,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    servicesList.add(Services(
      id: id,
      nome: services.nome,
      code: services.code,
      store: services.store,
    ));
    print("Service List $servicesList");

    update();
  }

  Future<void> updateServices(Services services) async {
    print("updateservice");
    int index = servicesList.indexWhere((p) => p.id == services.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_SERVICES}/$idUser/${services.id}.json',
        ),
        body: jsonEncode(
          {
            "nome": services.nome,
            "code": services.code,
            "store": services.store,
          },
        ),
      );

      servicesList[index] = services;
      update();
    }
  }



  addList(List<Services> result) {
    servicesList.clear();
    servicesList.assignAll(result);
    listaOriginal = result;
    itens = servicesList.length;
    print("5x $servicesList");
    _userName.value = result.first.nome;

    print("oringal $listaOriginal");
    update();
  }



  add(Services services) {
    print("city $services");
    servicesList.removeWhere((x) => x.id == services.id);
    servicesList.add(services);
    increase(services);
  }

  adds(List x) {
    print("VVVV $x");
    servicesList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      servicesList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = servicesList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    servicesList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Services services) {
    itens = 0;
    servicesList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    servicesList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    servicesList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = servicesList[1].nome;
  }

  remove(Services item) {
    print("INTES1 $itens");
    servicesList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeServices(Services services) async {
    int index = servicesList.indexWhere((p) => p.id == services.id);
   print("PP0 $index");
   print("PP00 ${services.id}");
    if (index >= 0) {
      final services = servicesList[index];
      servicesList.remove(services);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/services/$idUser/${services.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_SERVICES}/${services.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        servicesList.insert(index, services);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
