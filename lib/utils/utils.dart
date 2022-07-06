/*
 * 创建工具类
 * 蓝牙mac地址的解析
 */

import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';



class Utils{


  Utils._privateConstructor();


  static final Utils _instance = Utils._privateConstructor();


  static Utils get instance { return _instance;}


  /*
    获取mac地址的帮助类
  */
  String mac(ScanResult str, String deviceName){
    try {
      //第一种用于 蓝牙电子秤的项目
      if (str.advertisementData.serviceData.isNotEmpty) {
        return getServiceData(str.advertisementData.serviceData);
      }
      // 第二种运用在普通的 TMW公司的mac地址
      if (str.advertisementData.manufacturerData.isNotEmpty) {
        // 判断系统是否是苹果系统
        //if(Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.macOS) {
        return getManufacturerData(
            str.advertisementData.manufacturerData, deviceName);
        // }else{
        // ignore: unnecessary_null_comparison
        // if(str.device.id != null) {
        // return getMac(str.device.id);
        // }else{
        //return "S/N:N/A";
        // }
        // }
      }
      //return "S/N:N/A";
    }catch(e){
      // ignore: avoid_print
      print(e);
    }
    return "S/N:N/A";
  }


  String getMac(DeviceIdentifier id){
    var data2 = id.toString().split(":");
    return "S/N:${data2[0]}${data2[1]}${data2[2]}${data2[3]}${data2[4]}${data2[5]}";
    //return "S/N:"+data2[5]+data2[4]+data2[3]+data2[2]+data2[1]+data2[0];
  }


  // 用于蓝牙电子称项目
  String getServiceData(Map<String, List<int>> data) {

    if (data.isEmpty) {
      return "S/N:N/A";
    }

    List<String> res = [];

    String ok = '';

    data.forEach((key, value) {
      res.add(getHexArray(value));
    });

    for (var element in res) {
      ok+=element;
    }

    String data1 = ok.replaceAll(" ", "");
    var data2 = data1.split(",");
    if(data2.length>5) {
      return "S/N:${data2[5]}${data2[4]}${data2[3]}${data2[2]}${data2[1]}${data2[0]}";
    }else{
      return "S/N:N/A";
    }
  }


  // 解析蓝牙mac的地址
  String getManufacturerData(Map<int, List<int>> data, String deviceName) {
    if (data.isEmpty) {
      return "S/N:N/A";
    }
    // deviceName.contains("TMW022") || deviceName.contains("updateFirmware")
    List<String> res = [];

    data.forEach((id, bytes) {
      res.add(
          '${id.toRadixString(16).toUpperCase()}: ${getHexArray(bytes)}');
    });

    final datax = res.join("").replaceAll(" ", "");

    if(datax.length<17){

      var q = res.join(',');

      var m = q.split(":");
      var qq = "0000";
      if(m[0].length>3){
        var s1 = m[0].substring(0,2);
        var s2 = m[0].substring(2,4);
        qq = s2+s1;

        var qf = m[1].replaceAll(" ", "");
        var data2 = qf.split(",");
        var all = qq+data2[0]+data2[1]+data2[2]+data2[3];
        var all1 = all.toLowerCase();
        return "T$all1";

      }else if(m[0].length>2){
        var s1 = m[0].substring(0,1);
        var s2 = m[0].substring(1,3);
        qq = "${s2}0$s1";

        var qf = m[1].replaceAll(" ", "");
        var data2 = qf.split(",");
        var all = qq+data2[0]+data2[1]+data2[2]+data2[3];
        var all1 = all.toLowerCase();
        return "T$all1";

      }

      return "S/N:N/A";

      // String ok = '';
      // data.forEach((id, bytes) {
      //   res.add(
      //       getHexArray(bytes));
      // });
      //
      // for (var element in res) {
      //   ok+=element;
      // }
      // String data1 = ok.replaceAll(" ", "");
      // var data2 = data1.split(",");
      // return "S/N:"+data2[0]+data2[1]+data2[2]+data2[3];
      //return "S/N:ERROR";
    }else {
      data.forEach((id, bytes) {
        res.add(
            getHexArray(bytes));
      });

      final data1 = res.join("").replaceAll(" ", "");
      if (data1.length >= 17) {
        final data2 = data1.split(",");
        return "S/N:${data2[0]}${data2[1]}${data2[2]}${data2[3]}${data2[4]}${data2[5]}";
      } else {
        return "S/N:N/A";
      }
    }
  }

  // String getHexArray(List<int> bytes) {
  //   return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]'
  //       .toUpperCase();
  // }

  String getHexArray(List<int> bytes) {
    return bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')
        .toUpperCase();
  }

  String getOtaHexArray(List<int> bytes) {
    return bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')
        .toUpperCase();
  }

  String getTestHexArray(List<int> bytes) {
    return bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('')
        .toLowerCase();
  }


  String covertDataToASCII(List<int> data){
    var int2utf8 = Uint8List.fromList(data);
    var character = const Utf8Codec().decode(int2utf8);
    return character;

  }


  //将unicode或ascii编码类型的list(编码格式 长度 字符串内容)转换为String字符串
  String unicodeOrAsciiList2String(List<int> data){
    //获取字符串长度对应的数据
    List<int> lengthList = data.sublist(1,3);
    //获取字符串长度的int值
    int length = listToValue(lengthList);

    // ignore: avoid_print
    print("length is :$length");

    if(length == 0){     //长度为0
      return '';
    }else{             //长度不为0
      List<int> strList = data.sublist(3,data.length);
      String result='';
      if(data[0]==1){       //ASCII编码
        for (var value in strList) {
          result+=String.fromCharCode(value);
        }
        return result;
      }else if(data[0]==2){ //UNICODE编码
        for(int i=0;i<strList.length~/2;i++){
          List<int> current=  strList.sublist(i*2,(i+1)*2);
          result+=String.fromCharCode(listToValue(current));
        }
        return result;
      }
      return "";
    }
  }


  //将数组转换成int值  一般接收的时候需要
  int listToValue(List<int> data) {
    if(data.length == 2){
      return (data[1] << 8) + data[0];
    }else if(data.length == 4){
      return data[0] + (data[1] << 8) + (data[2] << 16) + (data[3] << 24);
    }else if(data.length == 8){
      return data[0] + (data[1] << 8) + (data[2] << 16) + (data[3] << 24) +
          (data[4] << 32) + (data[5] << 40) + (data[6] << 48) +
          (data[7] << 56);
    }else if(data.length == 16){
      return data[0] + (data[1] << 8) + (data[2] << 16) + (data[3] << 24) +
          (data[4] << 32) + (data[5] << 40) + (data[6] << 48) +
          (data[7] << 56) +
          (data[8] << 64) + (data[9] << 72) + (data[10] << 80) +
          (data[11] << 88) +
          (data[12] << 96) + (data[13] << 104) + (data[14] << 112) +
          (data[15] << 116);
    }else{
      return data[0];
    }
  }


  // 摄氏度转华氏度
  double convertCelciusToFahren(double celcius){
    return celcius * 1.8 + 32;
  }

  // 华氏度转摄氏度
  double convertFahrenToCelcius(double fahren){
    return (fahren - 32) / 1.8;
  }

  // CAL
  double convertCalToFahren(double celcius){
    return celcius * 1.8;
  }

  // 华氏度转摄氏度校验值
  double convertFToCelcius(double fahren){
    return fahren / 1.8;
  }




}