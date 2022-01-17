import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/exceptions/auth_exception.dart';
import 'package:shop/core/models/users.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/utils/alert.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _formData = Map<String, Object>();

  UsersController controler =  Get.put(UsersController());
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'nome':''
  };


  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Registrar
        print("VEEDD ${   _authData['nome']}");
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
          _authData['nome']!,


        );
        print("For $_authData");
      }
      print("For $_authData");
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }
  Future<void> _submitReset() async {
    if(_emailController.text==null|| _emailController.text==''){
      alert(context, "Digite um e-mail válido!");
    }else{
      Auth auth = Provider.of(context, listen: false);
      try {
        // Login
        await auth.sendPasswordResetEmail(
          _emailController.text,
        );
        toast(context, 'Solicitação enviada com sucesso!\nAcesse seu email e redefina!');

      } on AuthException catch (error) {
        _showErrorDialog(error.toString());
      } catch (error) {
        _showErrorDialog('Ocorreu um erro inesperado!');
      }

    }


  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 350 : 350,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.text,
                  onSaved: (nome) => _authData['nome'] = nome ?? '',
                  controller: _nomeController,
                  validator: (_nome) {
                    final nome = _nome ?? '';
                    if (nome.isEmpty || nome.length < 3) {
                      return 'Informe um nome  válida';
                    }
                    return null;
                  },
                ),

              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                controller: _emailController,
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isLogin())TextButton(
                onPressed: (){
                  _submitReset();
                  print("envia solicitação");
                },
                child: Text(
                  'Esqueci a Senha!',
                ),
              ),

              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Spacer(),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                ),


              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
