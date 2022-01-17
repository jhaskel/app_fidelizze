import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shop/core/controllers/card_list_controller.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/core/controllers/services_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';

import 'package:shop/core/models/qrcode.dart';
import 'package:shop/core/models/services.dart';
import 'package:shop/providers/auth.dart';



class BarcodePageValida extends StatefulWidget {
  Services service;
  Auth user;
  BarcodePageValida(this.service,this.user);


  @override
  _BarcodePageValidaState createState() => _BarcodePageValidaState();
}

class _BarcodePageValidaState extends State<BarcodePageValida> {
  ScanResult? scanResult;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  String qrCodeResult = "";
  List<Qrcode>? cupom;
//  final _bloc = QrcodeBloc();

  CardsController controler =  Get.put(CardsController());
  CardListController controler2 =  Get.put(CardListController());
  ServicesController controlerService =  Get.put(ServicesController());
  UsersController controlerUsers =  Get.put(UsersController());

  List<dynamic> listServices =[];
  List<Services> ser =[];

  final _formData = Map<String, Object>();
  bool _isLoading = false;


  String hoje = DateFormat("ddMMyyy").format(DateTime.now());

  iniciarScan() async {
    await _scan();
    initState();
    setState(() {
      qrCodeResult = scanResult!.rawContent;
      print("qrCodeResult ${qrCodeResult}");
    });
  }


  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    iniciarScan();
    controlerService.loadServicesCliente(widget.service.store);
  }

  @override
  Widget build(BuildContext context) {
    var user=Provider.of<Auth>(context);
   if(qrCodeResult==''){
     return Container();
   }
    return Scaffold(
      appBar: AppBar(
        title: Text("Validar Adesivo"),
        centerTitle: true,
      ),
    // body:_body(user)

      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          GetX<ServicesController>(
              builder: (_) {
                if(_.isErro.value){
                  return Center(child: Text("Ocorreu um erro insesperado!"),);
                }else if(_.servicesList.length==0){
                  return Center(child: Text("QRcode não é válido!"),);
                }
                else{
                  listServices = _.servicesList.value;
                  print("list ${listServices}");

                  var separa = widget.service.code.split(".");
                  var loja = separa[0];

                  if(loja == widget.user.userId){
                    print("cadastrando....");
                    _submitForm(user);

                  }else{
                    print("não cadastra....");
                    return Center(
                      child:  Text(
                        "Qrcode Não encontrado!",
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    );

                  }

                  return Container();
                }

              }),

            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeSanner =
                await iniciarScan(); //barcode scnner
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
  Future<void> _submitForm(Auth user) async {
    print("chegou");
    var separa = qrCodeResult.split(".");
    var idCliente = separa[0];
    var cliente = separa[1];
    var loja = widget.user.userId.toString();

    _formData.putIfAbsent("id", () => loja);
    _formData.putIfAbsent("store", () => loja);
    _formData.putIfAbsent("code", () => widget.service.code);
    _formData.putIfAbsent("createdAt", () => DateTime.now().toIso8601String());
    _formData.putIfAbsent("cliente", () => idCliente);
    print("02 $_formData");
    try {
      await controler.saveCards(_formData,true);
      _formData.putIfAbsent("nomeCliente", () => cliente);
      print("03 $_formData");
      await controler2.saveCardList(_formData,true);
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
     return null;
    }
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
        qrCodeResult=scanResult!.rawContent;
      } );
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


}