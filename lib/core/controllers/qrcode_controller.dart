

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/qrcode.dart';
import 'package:shop/data/store.dart';

class QrcodeController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList qrcodeList = [].obs;
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

   loadQrcode();
    super.onInit();
  }

  Future<void> loadQrcode() async {
    idUser='';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();

    try{
      isLoading(true);
      qrcodeList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_QRCODE}/$idUser.json'),
      );
      print('${AppConstants.BASE_URL_QRCODE}/$idUser.json');
      print("resposta ${response.body}");
      if (response.body == 'null') return;
      print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((qrcodeId, qrcodeData) {
        qrcodeList.add(
          Qrcode(
            id: qrcodeId,
            createdAt: qrcodeData['createdAt'],
            store: qrcodeData['store'],
            code: qrcodeData['code'],
            cliente: qrcodeData['cliente'],
          ),
        );
        print("qrcode ${qrcodeList.first.id}");
        addList1(qrcodeList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");

    }finally{
      isLoading(false);
    }
  }


  addList1(RxList qrcodeList) {
    listaOriginal = qrcodeList;
    itens = qrcodeList.length;
    print("SEr lsit ${qrcodeList}");

  update();
  }

  Future<void> saveQrcode(Map<String, Object> data) {
    print("aki");
    bool hasId = data['id'] != null;

    final qrcode = Qrcode(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      cliente: data['cliente'] as String,
      store: data['store'] as String,
      code: data['code'] as String,
      createdAt: data['createdAt'] as String,

    );

    if (hasId) {
      return updateQrcode(qrcode);
    } else {
      return addQrcode(qrcode);
    }
  }

  Future<void> addQrcode(Qrcode qrcode) async {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_QRCODE}/$idUser.json'),
      body: jsonEncode(
        {
          "cliente": qrcode.cliente,
          "code": qrcode.code,
          "store": idUser,
          "createdAt": qrcode.createdAt,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    qrcodeList.add(Qrcode(
      id: id,
      cliente: qrcode.cliente,
      code: qrcode.code,
      store: qrcode.store,
      createdAt: qrcode.createdAt,
    ));
    print("Service List $qrcodeList");
    update();
  }

  Future<void> updateQrcode(Qrcode qrcode) async {
    int index = qrcodeList.indexWhere((p) => p.id == qrcode.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_QRCODE}/$idUser/${qrcode.id}.json',
        ),
        body: jsonEncode(
          {
            "cliente": qrcode.cliente,
            "code": qrcode.code,
            "store": qrcode.store,
            "createdAt": qrcode.createdAt,
          },
        ),
      );

      qrcodeList[index] = qrcode;
      update();
    }
  }



  addList(List<Qrcode> result) {
    qrcodeList.clear();
    qrcodeList.assignAll(result);
    listaOriginal = result;
    itens = qrcodeList.length;
    print("5x $qrcodeList");

    print("oringal $listaOriginal");
    update();
  }



  add(Qrcode qrcode) {
    print("city $qrcode");
    qrcodeList.removeWhere((x) => x.id == qrcode.id);
    qrcodeList.add(qrcode);
    increase(qrcode);
  }

  adds(List x) {
    print("VVVV $x");
    qrcodeList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      qrcodeList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = qrcodeList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    qrcodeList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Qrcode qrcode) {
    itens = 0;
    qrcodeList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    qrcodeList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    qrcodeList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = qrcodeList[1].nome;
  }

  remove(Qrcode item) {
    print("INTES1 $itens");
    qrcodeList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeQrcode(Qrcode qrcode) async {
    int index = qrcodeList.indexWhere((p) => p.id == qrcode.id);
   print("PP0 $index");
   print("PP00 ${qrcode.id}");
    if (index >= 0) {
      final qrcode = qrcodeList[index];
      qrcodeList.remove(qrcode);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/qrcode/$idUser/${qrcode.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_QRCODE}/${qrcode.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        qrcodeList.insert(index, qrcode);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
