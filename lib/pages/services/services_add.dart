

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/services_controller.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/providers/auth.dart';


class ServicesAdd extends StatefulWidget {
  @override
  _ServicesAddState createState() => _ServicesAddState();
}

class _ServicesAddState extends State<ServicesAdd> {

  ServicesController controler =  Get.put(ServicesController());

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final services = arg as Services;
        _formData['id'] = services.id;
        _formData['nome'] = services.nome;
        _formData['code'] = services.code;
        _formData['store'] = services.store;
      }
    }
  }


  void updateImage() {
    setState(() {});
  }



  Future<void> _submitForm(Auth user) async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
  var code = "${user.userId}.${DateTime.now().millisecondsSinceEpoch.toString()}";

  _formData.putIfAbsent("code", () => code);
  _formData.putIfAbsent("store", () => user.userId.toString());
    setState(() => _isLoading = true);
print("01");
    try {

      print("02 $_formData");
      await controler.saveServices(_formData);

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
    var user=Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: ()=>_submitForm(user),
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
           /*   TextFormField(
                initialValue: _formData['code']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Code',
                ),

                onSaved: (name) => _formData['code'] = name ?? '',

              ),*/

              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                textInputAction: TextInputAction.next,

                onSaved: (name) => _formData['nome'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'Nome precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),



            ],
          ),
        ),
      ),
    );
  }
}
