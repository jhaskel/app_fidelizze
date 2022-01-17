import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(135, 206, 250, 0.5),
                    Color.fromRGBO(65, 105, 225, 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 30),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 50),
                      child: Image.asset("assets/images/logo.png",height: 125,),
                      ),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exemplo usado para explicar o cascade operator
// void main() {
//   List<int> a = [1, 2, 3];
//   a.add(4);
//   a.add(5);
//   a.add(6);
  
//   // cascade operator!
//   a..add(7)..add(8)..add(9);
  
//   print(a);
// }

