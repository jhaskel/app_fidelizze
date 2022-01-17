

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/data/store.dart';

class StoresController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList storesList = [].obs;
  RxList storeList = [].obs;
  RxList store = [].obs;
  RxList storesListCliente = [].obs;
  RxList allstoresList = [].obs;


  var _userName = "".obs;
  var _txtButton = "Second ".obs;
  var isErro = false.obs;
  List<dynamic> listaOriginal = [];

  get userName => _userName.value;
  set userName(value) => _userName.value = value;

  get txtButton => _txtButton.value;
  set txtButton(value) => _txtButton.value = value;
  var user;
  String idUser ='';

  @override
  void onInit() {
   loadStores();
  // loadStoress();
 //  loadStoreCliente();
    super.onInit();
  }
  Future<void> loadAllStores() async {

    try{
      isLoading(true);
      allstoresList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_STORES}.json'),
      );
      print('${AppConstants.BASE_URL_STORES}/.json');
      print("resposta stars'${response.body}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((storesId, storesData) {
        print("STO ${storesId}");
        print("ID ${idUser}");


        allstoresList.add(
          Stores(
            id: storesId,
            idd: storesData['idd'],
            nome: storesData['nome'],
            logo: storesData['logo'],
            adesivos: storesData['adesivos'],
            address: storesData['address'],
            createdAt: storesData['createdAt'],
            isopen: storesData['isopen'],
            isativo: storesData['isativo'],
            description: storesData['description'],
          ),
        );
        addList1(allstoresList);
      });

    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }
  Future<void> loadStoress() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      storesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_STORES}.json'),
      );
      print('${AppConstants.BASE_URL_STORES}/.json');
      print("resposta stors'${response.body}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((storesId, storesData) {
        print("STO ${storesId}");
        print("ID ${idUser}");
          storesList.add(
            Stores(
              id: storesId,
              idd: storesData['idd'],
              nome: storesData['nome'],
              logo: storesData['logo'],
              adesivos: storesData['adesivos'],
              address: storesData['address'],
              createdAt: storesData['createdAt'],
              isopen: storesData['isopen'],
              isativo: storesData['isativo'],
              description: storesData['description'],
            ),
          );

        print("STORELIST ${storesList.value}");

        addList1(storesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }
  Future<void> loadStore(String loja) async {
    print("LOJA $loja()");
    print("KI");

    try{
      isLoading(true);
      storeList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_STORES}.json'),
      );
      print('${AppConstants.BASE_URL_STORES}/.json');
      print("resposta stors'${response.body}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((storesId, storesData) {
        print("STO ${storesId}");
        print("ID ${idUser}");
        if(storesData['id']==loja){
          storeList.add(
            Stores(
              id: storesId,
              idd: storesData['idd'],
              nome: storesData['nome'],
              logo: storesData['logo'],
              adesivos: storesData['adesivos'],
              address: storesData['address'],
              createdAt: storesData['createdAt'],
              isopen: storesData['isopen'],
              isativo: storesData['isativo'],
              description: storesData['description'],
            ),
          );
        }


        print("STORELIST ${storesList.value}");

        addList1(storesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }
  Future<void> loadStores() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      storesList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_STORES}.json'),
      );
      print('${AppConstants.BASE_URL_STORES}/.json');
      print("resposta stors'${response.body}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((storesId, storesData) {
        print("STO ${storesId}");
        print("ID ${idUser}");

       if(storesId==idUser){
         storesList.add(
           Stores(
             id: storesId,
             idd: storesData['idd'],
             nome: storesData['nome'],
             logo: storesData['logo'],
             adesivos: storesData['adesivos'],
             address: storesData['address'],
             createdAt: storesData['createdAt'],
             isopen: storesData['isopen'],
             isativo: storesData['isativo'],
             description: storesData['description'],
           ),
         );
       }
       print("STORELIST ${storesList.value}");

        addList1(storesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }
  Future<void> loadStoreCliente() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();
    try{
      isLoading(true);
      storesListCliente.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_STORES}.json'),
      );
      print('${AppConstants.BASE_URL_STORES}/.json');
      print("resposta stors'${response.body}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((storesId, storesData) {
        print("STO ${storesId}");
        print("ID ${idUser}");


          storesListCliente.add(
            Stores(
              id: storesId,
              idd: storesData['idd'],
              nome: storesData['nome'],
              logo: storesData['logo'],
              adesivos: storesData['adesivos'],
              address: storesData['address'],
              createdAt: storesData['createdAt'],
              isopen: storesData['isopen'],
              isativo: storesData['isativo'],
              description: storesData['description'],
            ),
          );

        addList1(storesList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }




  addList1(RxList storesList) {
    listaOriginal = storesList;
    itens = storesList.length;
    print("SEr lsit ${storesList}");

  update();
  }

  Future<void> saveStores(Map<String, Object> data, bool salvar ) {
    print("aki $data");
    bool hasId = data['id'] != null;

    final stores = Stores(
      id:  data['id'] as String ,
      idd:  data['idd'] as String ,
      nome: data['nome'] as String,
      logo: data['logo'] as String,
      adesivos: data['adesivos'] as int,
      address: data['address'] as String,
      isopen: data['isopen'] as bool,
      isativo: data['isativo'] as bool,
      createdAt: data['createdAt'] as String,
      description: data['description'] as String,
    );

    if (hasId && !salvar) {
      return updateStores(stores);
    } else {
      return addStores(stores);
    }
  }

  Future<void> addStores(Stores stores, ) async {
    print("addStore");
    final response = await http.patch(
      Uri.parse('${AppConstants.BASE_URL_STORES}/${stores.id}.json'),
      body: json.encode(
        {
          'id': stores.id,
          "idd": stores.idd,
          "nome": stores.nome,
          "logo": stores.logo,
          "adesivos": stores.adesivos,
          "address": stores.address,
          "createdAt": stores.createdAt,
          "isopen": stores.isopen,
          "isativo": stores.isativo,
          "description": stores.description,
        },
      ),
    );
    storesList.add(Stores(
      id: stores.id,
      nome: stores.nome,
      idd: stores.idd,
      logo: stores.logo,
      adesivos: stores.adesivos,
      address: stores.address,
      createdAt: stores.createdAt,
      isopen: stores.isopen,
      isativo: stores.isativo,
      description: stores.description,
    ));

    update();
  }

  Future<void> updateStores(Stores stores) async {
    int index = storesList.indexWhere((p) => p.id == stores.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_STORES}/${stores.id}.json',
        ),
        body: jsonEncode(
          {
            "idd": stores.idd,
            "nome": stores.nome,
            "logo": stores.logo,
            "adesivos": stores.adesivos,
            "address": stores.address,
            "createdAt": stores.createdAt,
            "isativo": stores.isativo,
            "isopen": stores.isopen,
            "description": stores.description,
          },
        ),
      );

      storesList[index] = stores;
      update();
    }
  }



  addList(List<Stores> result) {
    storesList.clear();
    storesList.assignAll(result);
    listaOriginal = result;
    itens = storesList.length;
    print("5x $storesList");


    print("oringal $listaOriginal");
    update();
  }



  add(Stores stores) {
    print("city $stores");
    storesList.removeWhere((x) => x.id == stores.id);
    storesList.add(stores);
    increase(stores);
  }

  adds(List x) {
    print("VVVV $x");
    storesList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      storesList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = storesList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    storesList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Stores stores) {
    itens = 0;
    storesList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    storesList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    storesList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = storesList[1].nome;
  }

  remove(Stores item) {
    print("INTES1 $itens");
    storesList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeStores(Stores stores) async {
    int index = storesList.indexWhere((p) => p.id == stores.id);
   print("PP0 $index");
   print("PP00 ${stores.id}");
    if (index >= 0) {
      final stores = storesList[index];
      storesList.remove(stores);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/storess/${stores.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_STORES}/${stores.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        storesList.insert(index, stores);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
