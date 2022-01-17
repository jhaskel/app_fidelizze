import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/data/store.dart';
import 'package:shop/core/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  UsersController controler =  Get.put(UsersController());
  final _formData = Map<String, Object>();
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;
  late String idUser;


  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password,String urlFragment, String? nome) async {
    final url =

        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyBL1hYC-YFkSTzB4Dt0oCIPd2TT9rgTQ1w';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),

    );


    final body = jsonDecode(response.body);
    print("BDODY $body");
    print("BDODY ${_userId}");

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          days: 365,
        ),
      );
      idUser = _userId = body['localId'].toString();


      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      print("fragment $urlFragment");

   if(urlFragment=='signUp'){
     print("Cadastrou...");
     _formData['id'] = _userId.toString();
     _formData['nome'] = nome.toString();
     _formData['role'] = "cliente";
     _formData['email'] = _email.toString();
     await controler.saveUsers(_formData,true);
   }else{
     print("não cadastrou...");
   }
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password,[String? nome]) async {
    print("01 $email");
    print("02 $password");
    print("03 $nome");
    return _authenticate(email, password, 'signUp',nome);
  }


  Future<void> sendPasswordResetEmail(String email) async {
   print("email $email");
    final url =

        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyBL1hYC-YFkSTzB4Dt0oCIPd2TT9rgTQ1w';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        "requestType": "PASSWORD_RESET"
      }),

    );
   final body = jsonDecode(response.body);
   print("BDODY $body");

  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword',"");
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    print(timeToLogout);
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
