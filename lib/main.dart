import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/core/init/lazy.dart';
import 'package:shop/core/routes/app_pages.dart';
import 'package:shop/core/routes/app_routes.dart';

import 'package:shop/providers/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.init();
  runApp(MyApp());

  print("......................denovo................................");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),

      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.INITIAL,
        //theme: AppThemeLight.instance.theme,
        getPages: AppPages.pages,
      ),
    );
  }
}
