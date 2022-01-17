import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/core/controllers/product_controller.dart';
import 'package:shop/core/controllers/users_controller.dart';
import 'package:shop/core/models/product.dart';
import 'package:shop/core/routes/app_routes.dart';
import 'package:shop/providers/auth.dart';

class ProductPage extends StatelessWidget {
  List<dynamic> listProduct = [];
  TextEditingController _controllerNome = TextEditingController();
  ProductController controller = Get.put(ProductController());

  ProductPage();

  @override
  Widget build(BuildContext context) {
    return inicio(context);
  }

  GetX<ProductController> inicio(BuildContext context) {
    var user = Provider.of<Auth>(context);
    print("AGU ${user.email}");
    return GetX<ProductController>(builder: (_) {
      return Scaffold(

        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${user.email}"),
            ],
          ),
        ),
        body: _.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : _body(_),
      );
    });
  }

  _body(ProductController _) {
    if (_.isErro.value) {
      return Center(
        child: Text("Ocorreu um erro insesperado!"),
      );
    } else
      listProduct = _.productList.value;
    print("lk $listProduct");

    return Container(
        child: ListView.builder(
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              Product c = listProduct[index];
              return ListTile(
                title: Text(c.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // _.remove(c);
                        _.removeProduct(c);
                      },
                      icon: Icon(Icons.restore_from_trash),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed(Routes.PRODUCT_ADD, arguments: c);
                      },
                      icon: Icon(Icons.edit),
                    )
                  ],
                ),
              );
            }));
  }
}
