
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/core/controllers/cards_controller.dart';
import 'package:shop/providers/auth.dart';
class QrcodePage extends StatefulWidget {
  String nome;
  QrcodePage(this.nome,{Key? key}) : super(key: key);

  @override
  _QrcodePageState createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  CardsController controller = Get.put(CardsController());
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Auth>(context);
    if(user!=null){
      return Scaffold(
        
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              controller.loadCards();
              Get.back();
            }, icon: Icon(Icons.arrow_back,color: Colors.white,),
            
          ),
          title: Text(widget.nome),
        ),
        body: _body(user),
      );
    }else
    return Scaffold(
      appBar: AppBar(title: Text("Qrcode"),),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  _body(Auth user) {
    var cod = "${user.userId}.${widget.nome}";
    print("cod $cod");
    return Center(
      child: Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: cod,
              padding: EdgeInsets.all(2),
              gapless: true,
              size: 200,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
        ),
      ),
    );
  }
}
