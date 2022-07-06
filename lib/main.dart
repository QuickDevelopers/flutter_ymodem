import 'package:flutter/material.dart';
import 'package:flutter_ymodel/route/route_config.dart';
import 'package:flutter_ymodel/widgets/material_color.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RouteConfig.home,
      getPages: RouteConfig.getPages,
      theme: ThemeData(
          primaryIconTheme: const IconThemeData(color: Colors.white),
          primarySwatch: createMaterialColor(const Color(0xFF353535))
      ),
      debugShowCheckedModeBanner:false
    );
  }
}
