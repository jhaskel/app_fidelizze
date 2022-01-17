

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/providers/auth.dart';

class StoresAdd extends StatefulWidget {
  @override
  _StoresAddState createState() => _StoresAddState();
}

class _StoresAddState extends State<StoresAdd> {
  final _nomeFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _ardesivosFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  StoresController controler =  Get.put(StoresController());

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  bool isEditar= false;
  bool isOpen = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        setState(() {
          isEditar = true;
        });
        final stores = arg as Stores;
        isOpen = stores.isopen;
        _formData['id'] = stores.id;
        _formData['idd'] = stores.idd!;
        _formData['nome'] = stores.nome;
        _formData['address'] = stores.address;
        _formData['description'] = stores.description!;
        _formData['logo'] = stores.logo;
        _formData['adesivos'] = stores.adesivos;
        _imageUrlController.text = stores.logo;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _addressFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm(Auth user) async {
    print("userx ${user.userId}");
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    _formData.putIfAbsent("id", () => user.userId.toString());
    _formData.putIfAbsent("idd", () => user.userId.toString());
    _formData.putIfAbsent("isativo", () =>true);
    _formData.putIfAbsent("isopen", () =>!isEditar?true:isOpen);
    _formData.putIfAbsent("createdAt",() =>DateTime.now().toIso8601String());
    setState(() => _isLoading = true);

    try {
      if (isEditar) {
        await controler.saveStores(_formData,false);
      }else{
        await controler.saveStores(_formData,true);
      }




      Navigator.of(context).pop();
    } catch (error) {

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
    var userx=Provider.of<Auth>(context);
    print("userx ${userx.userId}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          IconButton(
            onPressed: ()=>_submitForm(userx),
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
              MergeSemantics(
                child: CupertinoSwitch(
                  value: isOpen,
                  onChanged: (bool newValue) async {
                    setState(() {
                      isOpen = newValue;
                    });
                   // recebeProduto(newValue, i);

                  },
                ),
              ),
              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                focusNode: _nomeFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_addressFocus);
                },
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
              TextFormField(
                initialValue: _formData['address']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Endereço',
                ),
                focusNode: _addressFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ardesivosFocus);
                },
                onSaved: (name) => _formData['address'] = name ?? '',
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'Endereço é obrigatório';
                  }

                  if (name.trim().length < 3) {
                    return 'Endereço precisa no mínimo de 3 letras.';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['adesivos']?.toString(),
                decoration: InputDecoration(labelText: 'Adesivos'),
                textInputAction: TextInputAction.next,
                focusNode: _ardesivosFocus,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (price) =>
                _formData['adesivos'] = int.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = int.tryParse(priceString) ?? -1;

                  if (price <= 0) {
                    return 'Informe uma quatidade válida.';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                decoration: InputDecoration(labelText: 'Descrição'),
                focusNode: _descriptionFocus,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocus);
                },
                maxLines: 3,
                onSaved: (description) =>
                _formData['description'] = description ?? '',
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'Descrição é obrigatória.';
                  }

                  if (description.trim().length < 10) {
                    return 'Descrição precisa no mínimo de 10 letras.';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                      InputDecoration(labelText: 'Url da Imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocus,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(userx),
                      onSaved: (imageUrl) =>
                      _formData['logo'] = imageUrl ?? '',
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a Url')
                        : Image.network(_imageUrlController.text),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
