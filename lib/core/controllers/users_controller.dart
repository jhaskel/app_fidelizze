import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop/core/constants/app_constants.dart';
import 'package:shop/core/exceptions/http_exception.dart';
import 'package:shop/core/models/users.dart';
import 'package:shop/data/store.dart';
import 'package:shop/providers/auth.dart';


class UsersController extends GetxController {

  var isLoading = true.obs;
  var isOk = false.obs;
  int itens = 0;
  RxList usersList = [].obs;
  RxList userList = [].obs;
  late Users users;
  var _userRole = "".obs;
  var _userNome = "".obs;
  var _txtButton = "Second ".obs;
  var isErro = false.obs;
  List<dynamic> listaOriginal = [];

  get userRole => _userRole.value;
  set userRole(value) => _userRole.value = value;

  get userNome => _userNome.value;
  set userNome(value) => _userNome.value = value;

  get txtButton => _txtButton.value;
  set txtButton(value) => _txtButton.value = value;

  @override
  Future<void> onInit() async {
    print("sim");
  await loadUsers();
    super.onInit();
  }

  Future<void> loadUsers() async {
    try{
      isLoading(true);
      usersList.clear();

      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_USERS}.json'),
      );

      print("PPPP00 ${AppConstants.BASE_URL_USERS}.json");
      print("PPPP1 ${response.body}");
      if (response.body == 'null') return;

      Map<String, dynamic> data = jsonDecode(response.body);
      data.forEach((usersId, usersData) {
         usersList.add(
          Users(
            id: usersId,
            nome: usersData['nome'],
            email: usersData['email'],
            role: usersData['role'],
           
          ),
        );
         usersList.sort((a, b) => a.nome.compareTo(b.nome));
        addList1(usersList);
      });

    }catch(e){
      addErro();
      print("ERRx $e");
      print("não foi possivel ler os dados");


    }finally{
      isLoading(false);
    }
  }

  Future<void> loadUser(String? idUsuario) async {
    print("Load $idUsuario");

      userList.clear();
      userRole = '';
      userNome = '';
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL_USERS}/$idUsuario.json'),
      );
      print("PPPP00 ${AppConstants.BASE_URL_USERS}/$idUsuario.json");
      print("PPPP10 ${response.body}");
      if (response.body == 'null') return;


      Map<String, dynamic> data = jsonDecode(response.body);

     print("DATA $data");
     userList.add(data);
      userRole = userList[0]['role'];
      userNome = userList[0]['nome'];
      print('user role $userRole');
      update();
  }


  addList1(RxList usersList) {
    print("certo");
    listaOriginal = usersList;
    itens = usersList.length;

  update();
  }


  Future<void> saveUsers(Map<String, Object> data,bool signup) {
    print("aki ${data['id']}");
    bool hasId = data['id'] != null;
    final users = Users(
      id:  data['id'] as String,
      nome: data['nome'] as String,
      email: data['email'] as String,
      role: data['role'] as String,
    );

    if (hasId && signup==false) {
      return updateUsers(users);
    } else {
      return addUsers(users);
    }
  }

  Future<void> addUsers(Users users) async {
    print("chegou");
    print("URL ${AppConstants.BASE_URL_USERS}/${users.id}.json");
    var url =  Uri.parse('${AppConstants.BASE_URL_USERS}/${users.id}.json');

    final response = await http.patch(
      url,
      body: json.encode({
        'id': users.id,
        'nome': users.nome,
        'email': users.email,
        'role': users.role,
      }),
    );

  //  final id = jsonDecode(response.body)['name'];
//    print("ID $id");
    usersList.add(Users(
      id: users.id,
      nome: users.nome,
      email: users.email,
      role: users.role,
    ));
    update();
  }

  Future<void> updateUsers(Users users) async {
    int index = usersList.indexWhere((p) => p.id == users.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${AppConstants.BASE_URL_USERS}/${users.id}.json',
        ),
        body: jsonEncode(
          {
            "nome": users.nome,
            "email": users.email,
            "role": users.role,
          },
        ),
      );

      usersList[index] = users;
      update();
    }
  }



  addList(List<Users> result) {
    usersList.clear();
    usersList.assignAll(result);
    listaOriginal = result;
    itens = usersList.length;
    print("5x $usersList");


    print("oringal $listaOriginal");
    update();
  }

  add(Users users) {
    print("city $users");
    usersList.removeWhere((x) => x.id == users.id);
    usersList.add(users);
    increase(users);
  }

  adds(List x) {
    print("VVVV $x");
    usersList.clear();

    //  var z = x.map((e) => e.id).toSet().toList();

    // print(" id = $z");
    for (var k in x) {
      usersList.add(k);
      increase(k);
    }
  }

  search(String nome) {
    print("LO1 $listaOriginal");
    var x = usersList.where((e) => e.nome.contains(nome)|| e.icone.contains(nome)).toList();
    adds(x);
    print("LO2 $listaOriginal");
  }

  retornaOriginal() {
    usersList.assignAll(listaOriginal);
  }

  addErro() {
    isErro(true);
  }

  increase(Users users) {
    itens = 0;
    usersList.forEach((x) {
      itens++;
    });
    update();
  }

  ordemCrescente() {
    usersList.sort((a, b) => a.nome.compareTo(b.nome));
    listaOriginal.sort((a, b) => a.nome.compareTo(b.nome));
  }

  ordemDecrescente() {
    usersList.sort((a, b) => b.nome.compareTo(a.nome));
    listaOriginal.sort((a, b) => b.nome.compareTo(a.nome));
  }

  changeNew(String tr) {
    txtButton = tr;
    update();
  }

  remove(Users item) {
    print("INTES1 $itens");
    usersList.removeWhere((x) => x.id == item.id);
    itens--;
    // decrease(item);
    print("INTES2 $itens");
    update();
  }

  Future<void> removeUsers(Users users) async {
    int index = usersList.indexWhere((p) => p.id == users.id);
   print("PP0 $index");
   print("PP00 ${users.id}");
    if (index >= 0) {
      final users = usersList[index];
      usersList.remove(users);
      update();

      final response = await http.delete(
        Uri.parse(
          'https://fidelizze-app-default-rtdb.firebaseio.com/users/${users.id}.json',
        ),
      );
      print("PP1 ${AppConstants.BASE_URL_USERS}/${users.id}.json");
      print("PP2 ${response.statusCode}");

      if (response.statusCode >= 400) {
        usersList.insert(index, users);
        update();
        throw HttpException(
          msg: 'Não foi possível excluir o produto.',
          statusCode: response.statusCode,
        );
      }
    }
  }

  void addUserList(RxList userList) {
    userRole = userList[0]['role'];
    update();
  }
}
