import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/resgates_controller.dart';
import 'package:shop/core/controllers/stores_controller.dart';
import 'package:shop/core/models/resgates.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';
import 'package:intl/intl.dart';
import 'package:shop/utils/utils.dart';

class ResgatesPage extends StatelessWidget {
  String titli = 'Getx Example';
  List<dynamic> listResgates =[];
  ResgatesController controller =  Get.put(ResgatesController());
 // StoresController controllerStore =  Get.put(StoresController());

  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<ResgatesController> inicio(BuildContext context) {
    var user=Provider.of<Auth>(context);

    print("AGU ${user.email}");
    return GetX<ResgatesController>(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Meus Resgates"),

            ),
            body: _.isLoading.value?
            Center(child: CircularProgressIndicator()):

            _body(_,user,context),
          );
        }
    );
  }

  _body(ResgatesController _, Auth user, BuildContext context) {

    if(_.isErro.value){
      return Center(child: Text("Ocorreu um erro insesperado!"),);
    }else if(_.resgatesList.length==0){
      return Center(child: Text("Nenhum Resgate  cadastrado!"),);
    }
    else
      listResgates = _.resgatesList.value;
    print("lk $listResgates");

    return Column(
      children: [
        Container(
          color: Colors.lightBlueAccent,
          height: 75,
          width: MediaQuery.of(context).size.width,
          child: Text("Você possui ${listResgates.length} cupons\npara concorrer  dia 25 de dezembro a premios no app",
            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: Container(
              child:  ListView.builder(
                  itemCount: listResgates.length,
                  itemBuilder: (context,index){
                    Resgates c = listResgates[index];
                    DateTime crea = DateTime.parse(c.createdAt);
                    var dia = crea.day;
                    var mes = crea.month;
                    var code = c.id.hashCode;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          gerarQrCode(context,c,user);
                        },
                        leading: CircleAvatar(radius:30,child: Center(child: Text(("$dia\n${NomeMes.mes[mes]}"),))),
                        title: Text(c.nomeLoja),
                        subtitle: Text(code.toString()),
                      ),
                    );
                  }
              )
          ),
        ),
      ],

    );
  }

  gerarQrCode(BuildContext context, Resgates c, Auth user) {
    double largura = 300;

    Widget cancelaButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("Código",style:  Theme.of(context).textTheme.headline3,),
      content:  Container(
        width: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: c.store,
              padding: EdgeInsets.all(2),
              gapless: true,
              size: 200,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
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
  showDeletar(BuildContext context, Resgates c, ResgatesController _) {

    Widget cancelaButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {

        Navigator.of(context).pop();
      },
    );
    Widget okButton = TextButton(
      child: Text("Excluir"),
      onPressed:  () {
        _.removeResgates(c);
        Navigator.of(context).pop();
      },
    );

    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("Tem certeza quer Deletar?",style:  Theme.of(context).textTheme.headline5,),
      content:  Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white,
            child: Text(
               c.cliente,
            ),
          ),
        ),
      ),
      actions: [
        cancelaButton,
        okButton
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


}
