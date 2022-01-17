import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:shop/core/controllers/card_list_controller.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/controllers/resgates_controller.dart';
import 'package:shop/core/controllers/services_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/qrcode.dart';
import 'package:shop/core/models/resgates.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/core/models/stores.dart';
import 'package:shop/core/models/users.dart';
import 'package:shop/providers/auth.dart';

class Barcode2Page extends StatefulWidget {
  @override
  _Barcode2PageState createState() => _Barcode2PageState();
}
class _Barcode2PageState extends State<Barcode2Page> {
  ScanResult? scanResult;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  String qrCodeResult = "";

  List<dynamic> listUsers = [];
  List<Users> usser = [];
  late String idLoja;
  late String idCliente;
  String? nomeLoja;


  UsersController controlerUser = Get.put(UsersController());
  ResgatesController controlerResgate = Get.put(ResgatesController());
  CardsController controlerCards = Get.put(CardsController());
  CardListController controlerCardList = Get.put(CardListController());

  final _formData = Map<String, Object>();

  iniciarScan() async {
    await _scan();
    if (!mounted) return;
    setState(() {
      qrCodeResult = scanResult!.rawContent;
      print("qrCodeResult1 ${qrCodeResult}");
    });
  }

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final dados = arg as Stores;
        nomeLoja = dados.nome;
        print("nomeLoja $nomeLoja");
      }  }
  @override
  void initState() {
    super.initState();
    print("01");
    iniciarScan();
    print("03");
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Auth>(context);
    if (qrCodeResult != '') {
      print("qrCodeResult $qrCodeResult");
      var loja = qrCodeResult.split(".");
       idLoja = loja[0];
       idCliente = loja[1];
      controlerUser.loadUser(idCliente);
      return Scaffold(
        appBar: AppBar(
          title: Text("Resgatar Brinde"),
          centerTitle: true,
        ),
        // body:_body(user)

        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GetX<UsersController>(builder: (_) {
                if (_.isErro.value) {
                  return Center(
                    child: Text("Ocorreu um erro insesperado!"),
                  );
                } else if (_.usersList.length == 0) {
                  return Center(
                    child: Text("QRcode não é válido!"),
                  );
                } else
                  listUsers = _.usersList.value;
                for (Users c in listUsers) {
                  usser.add(c);
                }
                var x = usser.map((e) => e.id).toList();
                if (x.contains(idCliente) && idLoja == user.userId ) {
                  print("cadastrando....");
                  _submitForm(user,idLoja,idCliente);
                } else {
                  print("não cadastra....");
                  return Center(
                    child: Text(
                      "Qrcode Não encontrado!",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Container();
              }),
              SizedBox(
                height: 20.0,
              ),
              MaterialButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () async {
                  String codeSanner = await iniciarScan(); //barcode scnner
                  if (!mounted) return;
                  setState(() {
                    qrCodeResult = codeSanner;
                  });
                },
                child: Text(
                  "Scanear",
                  style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
              )
            ],
          ),
        ),
      );
    }
    else return Scaffold(
      appBar: AppBar(
        title: Text("Resgatar Brinde"),
        centerTitle: true,
      ),

      body: Center(child: Text("Validação Falhou!"),),
    );


  }

  Future<void> _submitForm(Auth user, String idLoja, String idCliente) async {
    print("chegou");

    _formData.putIfAbsent("id", () => idCliente);
    _formData.putIfAbsent("store", () => idLoja.toString());
    _formData.putIfAbsent("ano", () => DateTime.now().year.toString());
    _formData.putIfAbsent("cliente", () => idCliente);
    _formData.putIfAbsent("createdAt", () => DateTime.now().toIso8601String());
    _formData.putIfAbsent("nomeLoja", () => nomeLoja.toString());
    print("02 $_formData");

    try {
print('cadastraond resgate');
      await controlerResgate.saveResgates(_formData);
      //deletar no cards/loja/usuario
print('deletando cars');
     await controlerCards.loadCardDeletar(idCliente,idLoja);
      //deletar no cardLst/lola/todos ids acima
print('deletando cardList');
      await controlerCardList.loadCardDeletar(idCliente,idLoja);
      Get.back();
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
    } finally {}
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      if (!mounted) return;
      setState(() {
        scanResult = result;
        qrCodeResult = scanResult!.rawContent;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _bloc.dispose();
  }


}
