
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/users.dart';


class UsersAdd extends StatefulWidget {
  @override
  _UsersAddState createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> {
  final _emailFocus = FocusNode();
  final _nomeFocus = FocusNode();  
  final _roleFocus = FocusNode();  
  
  UsersController controler =  Get.put(UsersController());

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final users = arg as Users;
        _formData['id'] = users.id;
        _formData['nome'] = users.nome;
        _formData['role'] = users.role;
        _formData['email'] = users.email;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _nomeFocus.dispose();
    _roleFocus.dispose();

  }


  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);
print("01");
    try {
      print("02 $_formData");
      await controler.saveUsers(_formData,false);
      Navigator.of(context).pop();
    } catch (error) {
      print("03");
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro para salvar o produto.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuários'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocus);
                },
                onSaved: (nome) => _formData['nome'] = nome ?? '',
                validator: (_nome) {
                  final nome = _nome ?? '';

                  if (nome.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (nome.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),
           /*   TextFormField(
                initialValue: _formData['email']?.toString(),
                decoration: InputDecoration(labelText: 'Email'),
                textInputAction: TextInputAction.next,
                focusNode: _roleFocus,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_roleFocus);
                },

                onSaved: (email) => _formData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';

                  if (email.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (email.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['role']?.toString(),
                decoration: InputDecoration(labelText: 'Role'),
                textInputAction: TextInputAction.next,
                focusNode: _roleFocus,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_roleFocus);
                },

                onSaved: (role) => _formData['role'] = role ?? '',
                validator: (_role) {
                  final role = _role ?? '';

                  if (role.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (role.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),*/


            ],
          ),
        ),
      ),
    );
  }
}
