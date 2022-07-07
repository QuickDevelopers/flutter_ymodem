import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import '../../model/ble_model.dart';
import '../../pigeon.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/load_state.dart';
import '../../widgets/tips_toast.dart';
import 'state.dart';


// tips: This is the method of using pigeon

class OtaLogic extends GetxController {

  final OtaState state = OtaState();

  // 频道 用于与 ios/Android 底层协议通讯

  YmodemRequestApi api = YmodemRequestApi();


  // 获取service
  service(BuildContext context,BleModel model) async {

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
            receiveData(context,model,c);
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
  receiveData(BuildContext context,BleModel model,BluetoothCharacteristic character) async{

    await character.setNotifyValue(true);

    state.subscription = character.value.listen((event) {
      if(event.isNotEmpty) {
        //接收数据
        var q = Utils.instance.getOtaHexArray(event);
        // ignore: avoid_print
        print("q is :$q");
        // 开始的第一包
        if (q != "") {


          YmodemResponse response = YmodemResponse();

          response.filename = state.fileName.value;
          response.filepath = state.filePath.value;
          response.status = "otaStart";
          response.operate = q;
          response.start = true;
          response.stop = false;

          // send data
          YmodemRequest request = api.getMessage(response) as YmodemRequest;

          var qq = request.data as List<int>;
          var current = request.current;
          var total = request.total;
          var msg = request.msg;

          // 打印q的值
          if(qq.isNotEmpty){
            // ignore: avoid_print
            print("q is write :${Utils.instance.getTestHexArray(qq)}");
            sendBleData(qq);
            receiveChannelData(current!, total!, msg!);

          }else{
            Toast.toast(context,
                msg: "receive data error!",
                position: ToastPosition.bottom);
          }

          // if stop ota , only use ios/macos
          if(msg == "stopOta"){
            //断开蓝牙
            disconnect(context, model);
          }
        }
      }
    });
  }

  // 发送开始符号
  sendBegin(){

    YmodemResponse response = YmodemResponse();

    response.status = "otaBegin";

    api.getMessage(response);

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

    YmodemResponse response = YmodemResponse();
    response.status = "otaStop";
    response.stop = true;

    api.getMessage(response);

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
