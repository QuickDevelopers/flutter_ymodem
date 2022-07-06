import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../../model/ble_model.dart';




class HomeItemPage extends StatelessWidget{

  final BleModel _result;

  const HomeItemPage(this._result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //判断必须是 Kitchen才能添加
    if (_result.name!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),

        child: SizedBox(
          child: Card(
            elevation: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 图片
                // displayImage(_result.rssi!)
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Container(
                        width: (20),
                        height: (20),
                        decoration: BoxDecoration(
                          color: color1(_result.rssi??0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(width: 0, style: BorderStyle.none),
                        ),
                      ),
                      Text("RSS: "+signal(_result.rssi??0),
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  ),
                ),
                //内容显示
                Expanded(child:             Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _result.device!.name,
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                      //分割线
                      const Divider(color: Colors.white,),
                      Text(
                        _result.mac!,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black38,
                          fontWeight: FontWeight.normal,
                          //letterSpacing: 1.5
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    }else{
      return const Visibility(child: Text(""),visible: false,);
      // return Text("",style: TextStyle(
      //   fontSize: 0.0
      // ));
    }
  }


  // 信号值
  String signal(int rss){
    var qq = "0";
    if(rss == 0){
      return qq;
    }
    var rssi = rss.abs();
    qq = rssi.toString();
    return qq;
  }

  MaterialColor color1(int rss){
    // 默认绿色
    var qq = Colors.grey;
    if(rss==0){
      return qq;
    }
    var rssi = rss.abs();
    if (rssi > 0 && rssi <= 20){
      qq = Colors.green;
    }else if(rssi > 20 && rssi <= 40){
      qq = Colors.green;
    }else if(rssi > 40 && rssi <= 60){
      qq = Colors.blue;
    }else if(rssi > 60 && rssi <= 80){
      qq = Colors.yellow;
    }else if(rssi > 80 && rssi <= 100){
      qq = Colors.red;
    }else{
      qq = Colors.grey;
    }
    return qq;
  }



  // 返回展示的图片
  Image displayImage(int rss){
    // 默认是显示 null
    Image qq = Image.asset('assets/images/lanya6@3x.png',width: 35, height: 35,);
    if(rss==0){
      return qq;
    }
    var rssi = rss.abs();
    if (rssi > 0 && rssi < 20){
      qq = Image.asset('assets/images/lanya5@3x.png',width: 35, height: 35,);
    }else if(rssi > 20 && rssi < 40){
      qq = Image.asset('assets/images/lanya4@3x.png',width: 35, height: 35,);
    }else if(rssi > 40 && rssi < 60){
      qq = Image.asset('assets/images/lanya3@3x.png',width: 35, height: 35,);
    }else if(rssi > 60 && rssi < 80){
      qq = Image.asset('assets/images/lanya3@3x.png',width: 35, height: 35,);
    }else if(rssi > 80 && rssi < 100){
      qq = Image.asset('assets/images/lanya1@3x.png',width: 35, height: 35,);
    }else{
      qq = Image.asset('assets/images/lanya6@3x.png',width: 35, height: 35,);
    }
    return qq;
  }


  String addressText(ScanResult str){
    //return getNiceServiceData(str.advertisementData.serviceData) ?? 'N/A';
    return getAddress(str.advertisementData.serviceData) ?? "S/N:N/A";
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


  String? getAddress(Map<String, List<int>> data){
    if (data.isEmpty) {
      return null;
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

    return "S/N:"+data2[5]+data2[4]+data2[3]+data2[2]+data2[1]+data2[0];

  }

}