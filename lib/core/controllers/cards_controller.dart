import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/controllers/card_list_controller.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/cards.dart';
import 'package:shop/data/store.dart';

class CardsController extends GetxController {
  var isLoading = true.obs;
  var isOk = false.obs;
  RxInt _itens = 0.obs;
  RxList cardsList = [].obs;
  RxList cardDeletar = [].obs;
  var _userName = "".obs;
  var _txtButton = "Second ".obs;
  var isErro = false.obs;
  List<dynamic> listaOriginal = [];

  get userName => _userName.value;
  set userName(value) => _userName.value = value;

  get txtButton => _txtButton.value;
  set txtButton(value) => _txtButton.value = value;

  get itens => _itens.value;
  set itens(value) => _itens.value = value;
  var user;
  String? idUser;

  @override
  void onInit() {
    //  loadCards();
    super.onInit();
  }

  Future<void> loadCar(String store) async {
    print("alterando");
    idUser = '';
    itens = 0;
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();

    try {
      isLoading(true);
      cardsList.clear();
      final response =
          await http.get(Uri.parse('${AppConstants.BASE_URL_CARDS}.json'));
      print('${AppConstants.BASE_URL_CARDS}.json');
      if (response.body == 'null') {
        itens = 0;
        print("ITENS ${itens}");
        update();
        return;
      } else
        print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((cardsId, cardsData) {
        print("JJJ${cardsData['cliente']}");
        if (idUser == cardsData['cliente'] && store == cardsData['store']) {
          cardsList.add(
            Cards(
              id: cardsId,
              createdAt: cardsData['createdAt'],
              store: cardsData['store'],
              code: cardsData['code'],
              cliente: cardsData['cliente'],
            ),
          );
        }
      });
      print("cards ${cardsList}");
      addList1(cardsList);
    } catch (e) {
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadCards() async {
    print("alterando");
    idUser = '';
    itens = 0;
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();

    try {
      isLoading(true);
      cardsList.clear();
      final response =
          await http.get(Uri.parse('${AppConstants.BASE_URL_CARDS}.json'));
      print('${AppConstants.BASE_URL_CARDS}.json');
      if (response.body == 'null') {
        itens = 0;
        print("ITENS ${itens}");
        update();
        return;
      } else
        print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((cardsId, cardsData) {
        print("JJJ${cardsData['cliente']}");
        if (idUser == cardsData['cliente']) {
          cardsList.add(
            Cards(
              id: cardsId,
              createdAt: cardsData['createdAt'],
              store: cardsData['store'],
              code: cardsData['code'],
              cliente: cardsData['cliente'],
            ),
          );
        }
      });
      print("cards ${cardsList}");
      addList1(cardsList);
    } catch (e) {
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadCardLojista({String? loja, String? cliente}) async {
    try {
      isLoading(true);
      cardsList.clear();
      print('${AppConstants.BASE_URL_CARDS}/$loja/$cliente.json');
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_CARDS}/$loja/$cliente.json'),
      );
      print('${AppConstants.BASE_URL_CARDS}/$loja/$cliente.json');
      print("resposta ${response.body}");
      if (response.body == 'null') {
        itens = 0;
        print("ITENS ${itens}");
        update();
        return;
      } else
        print("resposta ${response.body}");
      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((cardsId, cardsData) {
        print("data ${data}");
        cardsList.add(
          Cards(
            id: cardsId,
            createdAt: cardsData['createdAt'],
            store: cardsData['store'],
            code: cardsData['code'],
            cliente: cardsData['cliente'],
          ),
        );
      });
      print("cards ${cardsList.first.id}");
      addList1(cardsList);
    } catch (e) {
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dadosx");
    } finally {
      isLoading(false);
    }
  }

  addList1(RxList cardsList) {
    listaOriginal = cardsList;
    itens = cardsList.length;
    print("SEr lsit ${cardsList}");
    print("ITENS ${itens}");

    update();
  }

  Future<void> saveCards(Map<String, Object> data, bool add) async {
    idUser = '';
    user = await Store.getMap('userData');
    idUser = user['userId'];
    print("iduser'${idUser}");
    update();

    final cards = Cards(
      id: data['id'] as String,
      cliente: data['cliente'] as String,
      store: data['store'] as String,
      code: data['code'] as String,
      createdAt: data['createdAt'] as String,
    );

    if (!add) {
      return updateCards(cards);
    } else {
      return addCards(cards);
    }
  }

  Future<void> addCards(
    Cards cards,
  ) async {
    print("ADD card");
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_CARDS}.json'),
      body: jsonEncode(
        {
          "cliente": cards.cliente,
          "code": cards.code,
          "store": cards.store,
          "createdAt": cards.createdAt,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    cardsList.add(Cards(
      id: id,
      cliente: cards.cliente,
      code: cards.code,
      store: cards.store,
      createdAt: cards.createdAt,
    ));
    print("Service List $cardsList");
    update();
  }

  Future<void> updateCards(Cards cards) async {
    print("update card");
    int index = cardsList.indexWhere((p) => p.id == cards.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_CARDS}/$idUser/${cards.id}.json',
        ),
        body: jsonEncode(
          {
            "cliente": cards.cliente,
            "code": cards.code,
            "store": cards.store,
            "createdAt": cards.createdAt,
          },
        ),
      );

      cardsList[index] = cards;
      update();
    }
  }

  addList(List<Cards> result) {
    cardsList.clear();
    cardsList.assignAll(result);
    listaOriginal = result;
    itens = cardsList.length;
    print("5x $cardsList");

    print("oringal $listaOriginal");
    update();
  }

  add(Cards cards) {
    print("city $cards");
    cardsList.removeWhere((x) => x.id == cards.id);
    cardsList.add(cards);
    increase(cards);
  }

  adds(List x) {
    print("VVVV $x");
    cardsList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      cardsList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = cardsList
        .where((e) => e.nome.contains(nome) || e.icone.contains(nome))
        .toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    cardsList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Cards cards) {
    itens = 0;
    cardsList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    cardsList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    cardsList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = cardsList[1].nome;
  }

  remove(Cards item) {
    print("INTES1 $itens");
    cardsList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);

    update();
  }

  Future<void> removeCards(Cards cards) async {
    int index = cardsList.indexWhere((p) => p.id == cards.id);
    print("PP0 $index");
    print("PP00 ${cards.id}");
    if (index >= 0) {
      final cards = cardsList[index];
      cardsList.remove(cards);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/cards/$idUser/${cards.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_CARDS}/${cards.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        cardsList.insert(index, cards);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }

  //vem do barcode2
  Future<void> removeAllCards(String idCliente, String idLoja) async {
    final response = await http.delete(
      Uri.parse(
        'https://fidelizze-app-default-rtdb.firebaseio.com/cards/$idLoja/$idCliente.json',
      ),
    );
    print("PP1 ${AppConstants.BASE_URL_CARDS}/$idLoja/$idCliente.json");
    print("PP2 ${response.statusCode}");
    if (response.statusCode >= 400) {
      update();
      throw HttpException(
        msg: 'Não foi possível excluir o produto.',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> loadCardDeletar(String cliente, String loja) async {
    try {
      isLoading(true);
      cardDeletar.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_CARDS}.json'),
      );
      print('${AppConstants.BASE_URL_CARDS}.json');
      print("resposta88 ${response.body}");
      print("resposta89 ${cardsList}");

      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      print("data ${data}");
      data.forEach((scardListId, scardListData) {
        cardDeletar.add(
          Cards(
            id: scardListId,
            cliente: scardListData['cliente'],
            createdAt: scardListData['createdAt'],
            store: scardListData['store'],
            code: scardListData['code'],
          ),
        );
      });
      print("HHHH ${cardDeletar.value}");
      var f = cardDeletar
          .where((e) => e.cliente == cliente && e.store == loja)
          .toList();
      var t = f.map((e) => e.id);
      for (var x in t) {
        print("removendo $x....");
        removeCard(x);
      }
      print("deletar ${t.length}");
    } catch (e) {
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeCard(String card) async {
    int index = cardDeletar.indexWhere((p) => p.id == card);
    print("PP0 $index");
    print("PP00 ${card}");
    if (index >= 0) {
      update();

      final response = await http.delete(
        Uri.parse(
          '${AppConstants.BASE_URL_CARDS}/$card.json',
        ),
      );
      print("delete ${AppConstants.BASE_URL_CARDS}/${card}.json");
      print("PP2 ${response.statusCode}");
      if (response.statusCode >= 400) {
        //  cardsList.insert(index, scardList);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o card.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
