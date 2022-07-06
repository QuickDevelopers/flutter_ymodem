import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import '../../model/ble_model.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/load_state.dart';
import '../../widgets/tips_toast.dart';
import 'state.dart';

class OtaLogic extends GetxController {

  final OtaState state = OtaState();

  // 频道 用于与 ios/Android 底层协议通讯
  var channel = const MethodChannel('com.flutter.guide.YModemChannel');

  // 获取service
  service(BleModel model) async {

    state.bleModel.value = model;

    try {
      var services = await model.device!.discoverServices();
      // ignore: unnecessary_null_comparison
      if(services == null){
        state.loadState.value = LoadState.State_Error;
      }

      for (var element in services) {
        var characteristics = element.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == Constants.PROJECT_OTA) {
            state.otaCharacter = c;
            // 打开通知
            receiveData(c);
          }
        }
      }
    }catch(error){
      // ignore: avoid_print
      print("firstWhere error = $error");
      state.loadState.value = LoadState.State_Error;
    }
  }


  // 停止通知
  stopNotify(BluetoothCharacteristic character) async{
    // 关闭通知
    await character.setNotifyValue(false);
  }


  // 读取蓝牙数据
  receiveData(BluetoothCharacteristic character) async{

    await character.setNotifyValue(true);

    state.subscription = character.value.listen((event) {
      if(event.isNotEmpty) {
        //接收数据
        var q = Utils.instance.getOtaHexArray(event);
        // ignore: avoid_print
        print("q is :$q");
        // 开始的第一包
        if (q != "") {
          // 发送数据
          channel.invokeMethod(
              "otaStart", {"fileName": state.fileName.value,"filePath":state.filePath.value, "otaStatus": q});
        }
      }
    });
  }

  // 发送开始符号
  sendBegin(){
    // 发送数据
    channel.invokeMethod(
        "otaBegin", {"otaBegin":"begin"});
  }


  // 接收原生态蓝牙数据
  receiveCallData(BuildContext context,BleModel model){
    channel.setMethodCallHandler((MethodCall call){
      var q = call.arguments["data"] ?? [];
      var current = call.arguments["current"] ?? 0;
      var total = call.arguments["total"] ?? 0;
      var msg = call.arguments['msg'] ?? "";

      // 打印q的值
      if(q != null){
        // ignore: avoid_print
        //print("q is write :"+Utils.instance.getTestHexArray(q));
        sendBleData(q);
        receiveChannelData(current, total, msg);

        // if(msg == "Finish"){
        //   //断开蓝牙
        //   disconnect(context, model);
        // }

      }else{
        Toast.toast(context,
            msg: "receive data error!",
            position: ToastPosition.bottom);
      }

      // 如果是停止ota
      if(msg == "stopOta"){
        //断开蓝牙
        disconnect(context, model);
      }
      return q;
    });
  }

  // 获取数据
  receiveChannelData(int current, int total, String msg){
    // ignore: avoid_print
    print("current:$current total:$total message:$msg");
    if(current != 0 && total != 0) {
      // 返回布局
      var c = current.toDouble() / total.toDouble();
      state.progress.value = c;
    }
  }

  // 发送蓝牙数据
  sendBleData(List<int> data) async{
    try {
      // ignore: avoid_print
      //print("该长度为:" + data.length.toString());
      await state.otaCharacter?.write(data);
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
    }
  }

  // 停止ota升级
  sendOtaStop() async{
    // 发送停止的命令
    channel.invokeMethod(
        "otaStop", {"isStop": true});
  }

  sendOtaStart() async{
    //点击开始
    state.progress.value = 0.0;

    List<int> bytes = [5];
    await state.otaCharacter?.write(bytes);
  }

  disconnect(BuildContext context,BleModel model) async{
    if(model.device != null) {
      await model.device?.disconnect();
    }
  }

  // 接收蓝牙是否连接与断开连接最重要
  notice(BuildContext context,BleModel model) {
    state.subscription = model.device?.state.listen((event) async {
      switch (event) {
        case BluetoothDeviceState.connected:
        // ignore: avoid_print
          print("蓝牙已经连接");
          state.disconnect.value = false;
          break;
        case BluetoothDeviceState.disconnected:
          try {
            // ignore: avoid_print
            print("蓝牙已经断开连接");
            state.disconnect.value = true;
            // 界面关闭
            close(context);
          }catch(e){
            // ignore: avoid_print
            print(e);
          }

          break;
        case BluetoothDeviceState.connecting:
        // ignore: avoid_print
          print("蓝牙正在连接中....");
          break;
        case BluetoothDeviceState.disconnecting:
        // ignore: avoid_print
          print("蓝牙已经断开连接中....");
          break;
        default:
          break;
      }
    });
  }

  // 关闭界面
  close(BuildContext context){
    // 当断开的时候 页面自动关闭
    if (state.disconnect.value && !state.isConnect) {
      if (state.subscription != null) {
        state.subscription?.cancel();
        state.subscription = null;
      }
      // 返回上一个界面
      Get.back();
      //Navigator.pop(context);
    }
  }

  // 界面退出
  exit(BuildContext context, BleModel model) async{
    try {
      if (model.device != null) {
        //断开当前蓝牙连接
        await model.device?.disconnect();
      }
      if (state.subscription != null) {
        state.subscription?.cancel();
        state.subscription = null;
      }
      state.isConnect = true;
    }catch(e){
      // ignore: avoid_print
      print("error: $e");
    }
    Get.back();
  }


  @override
  void dispose() {
    // ignore: avoid_print
    print("释放界面");
    super.dispose();
  }

}
