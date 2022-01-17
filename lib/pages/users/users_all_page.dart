
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/controllers/card_list_controller.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/core/models/users.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';


class UsersAllPage extends StatefulWidget {

  @override
  State<UsersAllPage> createState() => _UsersAllPageState();
}

class _UsersAllPageState extends State<UsersAllPage> {
  String titli = 'Usuários';

  List<dynamic> listUsers =[];
   late String code;
   late String cliente;
   late String nomeCliente;

  TextEditingController _controllerNome = TextEditingController();

  UsersController controler =  Get.put(UsersController());
  CardsController controlerCards =  Get.put(CardsController());
  CardListController controlerCardList =  Get.put(CardListController());
  final _formData = Map<String, Object>();

  String? get nomeUser => null;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final services = arg as Services;
        code = services.code;
      }

  }

  @override
  Widget build(BuildContext context) {

    return inicio(context);

  }

  GetX<UsersController> inicio(BuildContext context) {


    return GetX<UsersController>(
      builder: (_) {
        return Scaffold(

          appBar: AppBar(
            title: Text(titli),

          ),
          body: _.isLoading.value?
          Center(child: CircularProgressIndicator()):

          _body(_,context),
        );
      }
  );
  }

  _body(UsersController _, BuildContext context) {
    var user=Provider.of<Auth>(context);
    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else
      listUsers = _.usersList.value;
    print("lk $listUsers");
    return Container(
        child:  ListView.builder(
            itemCount: listUsers.length,
            itemBuilder: (context,index){
              Users c = listUsers[index];
              return ListTile(
                title: Text(c.nome),
                subtitle: Text(c.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    IconButton(onPressed: (){
                      setState(() {
                        nomeCliente=c.nome;
                        cliente =c.id;

                      });
                     showValidar(context,nomeCliente,cliente);
                    },icon: Icon(Icons.star,color: Colors.amber,),)
                  ],

                ),
              );

            }
        )

    );
  }

  showValidar(BuildContext context, String nomeCliente, String cliente,) {

    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        _submit(nomeUser);
        Navigator.of(context).pop();
        
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("Validar Adesivo",style:  Theme.of(context).textTheme.headline5,textAlign: TextAlign.center,),
      content:  Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: Text(nomeCliente)
          ),
        ),
      ),
      actions: [
        cancelaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _submit(String? nomeUser) async {
    print("chegou");
    var separa = code.split(".");
    var loja = separa[0];

    _formData.putIfAbsent("id", () => loja);
    _formData.putIfAbsent("store", () => loja);
    _formData.putIfAbsent("code", () => code);
    _formData.putIfAbsent("createdAt", () => DateTime.now().toIso8601String());
    _formData.putIfAbsent("cliente", () => cliente);
    print("02 $_formData");
    try {
      await controlerCards.saveCards(_formData,true);
      _formData.putIfAbsent("nomeCliente", () => nomeCliente);
      print("03 $_formData");
      await controlerCardList.saveCardList(_formData,true);
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

    }
  }
}
