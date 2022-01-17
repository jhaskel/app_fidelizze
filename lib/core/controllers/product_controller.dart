

import 'dart:convert';

import 'dart:math';


import 'package:get/get.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/product.dart';

class ProductController extends GetxController {


  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList productList = [].obs;
  var _userName = "".obs;
  var _txtButton = "Second ".obs;
  var isErro = false.obs;
  List<dynamic> listaOriginal = [];

  get userName => _userName.value;
  set userName(value) => _userName.value = value;

  get txtButton => _txtButton.value;
  set txtButton(value) => _txtButton.value = value;

  @override
  void onInit() {
    print("sim");
   loadProducts();
    super.onInit();
  }

  Future<void> loadProducts() async {

    try{
      isLoading(true);
      productList.clear();
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_PRODUCT}.json'),
      );
      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((productId, productData) {
        productList.add(
          Product(
            id: productId,
            name: productData['name'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: false,
          ),
        );
        addList1(productList);
      });


    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");


    }finally{
      isLoading(false);
    }
  }


  addList1(RxList productList) {
    listaOriginal = productList;
    itens = productList.length;
   _userName.value = productList.first.name;
  update();
  }


  Future<void> saveProduct(Map<String, Object> data) {
    print("aki");
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL_PRODUCT}.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    productList.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    update();
  }

  Future<void> updateProduct(Product product) async {
    int index = productList.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_PRODUCT}/${product.id}.json',
        ),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      productList[index] = product;
      update();
    }
  }



  addList(List<Product> result) {
    productList.clear();
    productList.assignAll(result);
    listaOriginal = result;
    itens = productList.length;
    print("5x $productList");
    _userName.value = result.first.name;

    print("oringal $listaOriginal");
    update();
  }



  add(Product product) {
    print("city $product");
    productList.removeWhere((x) => x.id == product.id);
    productList.add(product);
    increase(product);
  }

  adds(List x) {
    print("VVVV $x");
    productList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      productList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = productList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    productList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Product product) {
    itens = 0;
    productList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    productList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    productList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  changeValue() {
    userName = productList[1].nome;
  }

  remove(Product item) {
    print("INTES1 $itens");
    productList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeProduct(Product product) async {
    int index = productList.indexWhere((p) => p.id == product.id);
   print("PP0 $index");
   print("PP00 ${product.id}");
    if (index >= 0) {
      final product = productList[index];
      productList.remove(product);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/products/${product.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_PRODUCT}/${product.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        productList.insert(index, product);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
