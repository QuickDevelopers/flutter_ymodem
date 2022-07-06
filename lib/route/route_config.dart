import 'package:get/get.dart';

import '../pages/home/view.dart';
//import '../launch_page.dart';

class RouteConfig{
  //static final String main = "/";
  static const String home = "/";
  static const String operate = "/operate";
  static const String ble = "/ble";
  static const String handle = "/handle";
  static const String add = "/add";
  static const String bleSet = "/bleSet";

  static final List<GetPage> getPages = [
    GetPage(name: home, page: ()=>HomePage()),
  ];

}