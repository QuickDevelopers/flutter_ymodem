
// 创建蓝牙工具类
import 'package:flutter_blue/flutter_blue.dart';

import '../model/ble_model.dart';


class BleUtil{

  BleUtil._privateConstructor();

  static final BleUtil _instance = BleUtil._privateConstructor();

  static BleUtil get instance { return _instance;}

  FlutterBlue flutterBlue = FlutterBlue.instance;


  // 开始扫描蓝牙
  List<BleModel> scan(){

    List<BleModel> result = [];

    flutterBlue.stopScan();

    flutterBlue.startScan(timeout: const Duration(seconds: 10));

    flutterBlue.scanResults.listen((event) {
      for(var m in event){
        if(m.device.name != ""){
          var model = BleModel();
          model.name = m.device.name;
          model.mac = addressText(m);
          model.select = false;
          model.rssi = m.rssi.toInt();
          result.add(model);
        }
      }
    });

    return result;
  }


  stop(){
    flutterBlue.stopScan();
  }

  /*
    获取mac地址的帮助类
  */
  String addressText(ScanResult str){
    // 第一种运用在 电子秤上面
    //return getAddress(str.advertisementData.serviceData) ?? "S/N:N/A";

    // 第二种运用在普通的 TMW公司的mac地址
    return getManufacturerData(str.advertisementData.manufacturerData);
  }

  String? getNiceServiceData(Map<String, List<int>> data) {
    if (data.isEmpty) {
      return null;
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add('${id.toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }


  String getNiceHexArray(List<int> bytes) {
    return bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')
        .toUpperCase();
  }


  // 用于蓝牙电子陈项目
  String getAddress(Map<String, List<int>> data) {

    if (data.isEmpty) {
      return "S/N:N/A";
    }

    List<String> res = [];

    String ok = '';

    data.forEach((key, value) {
      res.add(getNiceHexArray(value));
    });

    for (var element in res) {
      ok+=element;
    }

    //String data1 = ok.replaceAll(",", "");
    String data1 = ok.replaceAll(" ", "");
    var data2 = data1.split(",");
    return "S/N:${data2[5]}${data2[4]}${data2[3]}${data2[2]}${data2[1]}${data2[0]}";
  }


  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return "S/N:N/A";
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getNiceHexArray(bytes)}');
    });
    return res.join(', ');
  }


  // 解析蓝牙mac的地址
  String getManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return "S/N:N/A";
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          getNiceHexArray(bytes));
    });

    final data1 = res.join("").replaceAll(" ", "");

    if(data1.length >= 17) {
      final data2 = data1.split(",");
      return "S/N:${data2[0]}${data2[1]}${data2[2]}${data2[3]}${data2[4]}${data2[5]}";
    }else{
      return "S/N:N/A";
    }
  }

}