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



class BarcodePage extends StatefulWidget {

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
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
  bool? validou;
  String val="";

  String ho="";
  bool ok =false;
  bool _isLoading_ecoins = false;
  double ecoins = 0.0;
  bool cadastrou = true;
  String hoje = DateFormat("ddMMyyy").format(DateTime.now());
  String? nomeUser;
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

    print("01");
    iniciarScan();
    print("03");
  }

  @override
  Widget build(BuildContext context) {
    nomeUser = controlerUsers.userNome;
    if(qrCodeResult != ''){
      print("qrCodeResult $qrCodeResult");
      var loja = qrCodeResult.split(".");
      var idLoja = loja[0];
      print("IDLOJA $idLoja");
      controlerService.loadServicesCliente(idLoja);
    }

    var user=Provider.of<Auth>(context);

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
                else

                  listServices = _.servicesList.value;
                  for(Services c in listServices){
                    ser.add(c);
                  print("code${c.code}");

                }
                  var x = ser.map((e) => e.code).toList();
                if(x.contains(qrCodeResult)){
                  print("cadastrando....");
                  _submitForm(user,nomeUser);
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

                print("list ${listServices}");


                return Container();
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

  Future<void> _submitForm(Auth user, String? nomeUser) async {
    print("chegou");
    var separa = qrCodeResult.split(".");
    var loja = separa[0];

    _formData.putIfAbsent("id", () => loja);
    _formData.putIfAbsent("store", () => loja);
    _formData.putIfAbsent("code", () => qrCodeResult);
    _formData.putIfAbsent("createdAt", () => DateTime.now().toIso8601String());
    _formData.putIfAbsent("cliente", () => user.userId.toString());
    print("02 $_formData");
    try {
      await controler.saveCards(_formData,true);
      _formData.putIfAbsent("nomeCliente", () => nomeUser!);
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

  @override
  void dispose() {

    super.dispose();

   // _bloc.dispose();
  }


}