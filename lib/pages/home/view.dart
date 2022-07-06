import 'package:dialogs/dialogs/choice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:get/get.dart';
import '../../model/ble_model.dart';
import '../../widgets/load_state.dart';
import '../../widgets/tips_toast.dart';
import '../ota/view.dart';
import 'item/home_item_page.dart';
import 'logic.dart';

/*
 * 主界面显示 Update 更新为蓝牙界面 蓝牙界面作为主要的界面 删除不需要的界面 2022 year 12/31
 */
// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());
  final state = Get.find<HomeLogic>().state;

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE List"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.autorenew_rounded),
            onPressed: (){
              //点击事件
              //logic.scan(context, bleName);
              logic.scan(state.bleName);
            },
          )
        ],
        // leading: IconButton(
        //     icon: const Icon(Icons.wifi),
        //     onPressed: () async {
        //       if(state.subscription != null) {
        //         state.subscription!.cancel();
        //         state.subscription = null;
        //       }
        //       // 跳转wifi的界面
        //       //Get.to(()=>WifiPage());
        //     }),
      ),

      body: StreamBuilder(
        stream: FlutterBlue.instance.state,
        initialData: loadBleData(context),
        builder: (context, snapshot){
          if(snapshot.data == BluetoothState.on){
            return Obx(() =>
                LoadStateLayout(
                  state: state.loadState.value,
                  emptyRetry: (){
                    logic.scan(state.bleName);
                  },
                  errorRetry: (){
                    logic.scan(state.bleName);
                  },
                  successWidget: EasyRefresh(
                      header: MaterialHeader(),
                      onRefresh: () async{
                        await Future.delayed(const Duration(milliseconds: 1000));
                        // 扫描蓝牙
                        logic.scan(state.bleName);
                      },
                      child: ListView.builder(
                        itemCount:  state.bleList.isNotEmpty ? state.bleList.length : 0,
                        itemBuilder: _buildItem,
                      )),
                )
            );
          }else {
            state.loadState.value = LoadState.State_Empty;
            return LoadStateLayout(
              state: state.loadState.value,
              emptyRetry: (){
                logic.scan(state.bleName);
              },
            );
          }
        },
      ),
      // floatingActionButton: FancyButton(
      //   onPressed: () {
      //     Get.to(() => DevicesPage());
      //     //Get.toNamed("/add");
      //   },
      //   str: 'Device',
      // ),
    );
  }

  Widget _buildItem(BuildContext context, int index){
    BleModel _result = state.bleList[index];
    return InkWell(
      //单击事件
      onTap: () async {
        showAlertDialog(context, _result);
      },
      //长按事件
      onLongPress:()async {
        Clipboard.setData(ClipboardData(text: state.bleList[index].mac));
        Toast.toast(context,
            msg: "Copy successfully!",
            position: ToastPosition.bottom);
      },
      child: HomeItemPage(_result),
    );
  }


  Future<String> loadBleData(BuildContext context) async {
    await logic.scan(state.bleName);
    return "end";
  }

  showAlertDialog(BuildContext context, BleModel model){
    // input Ota, cloud yourself use project device name
    if(model.name!.contains("update")){
      return ChoiceDialog(
        title: "Connect Ota",
        message: "Do you want to connect Bluetooth?",
        buttonCancelOnPressed: () {
          Navigator.pop(context);
        },
        buttonOkOnPressed: () async {
          Navigator.pop(context);
          try {
            // stop scan
            logic.stop();

            if (state.subscription != null) {
              state.subscription?.cancel();
            }

            if (model.device != null) {
              // bluetooth disconnect
              await model.device!.disconnect();
            }
            if (model.device != null) {
              // connect bluetooth
              await model.device?.connect();
            }
            Get.to(() => OtaPage(), arguments: model);
          }catch(e){
            // ignore: avoid_print
            print("connect = $e");
            logic.scan(state.bleName);
          }
        },
      ).show(context);
    }else {
      return ChoiceDialog(
        title: "Connect",
        message: "Do you want to connect Bluetooth?",
        buttonCancelOnPressed: () {
          Navigator.pop(context);
        },
        buttonOkOnPressed: () async {
          Navigator.pop(context);
          try {
            // 停止扫描
            logic.stop();

            if (state.subscription != null) {
              state.subscription?.cancel();
            }

            if (model.device != null) {
              // 当前的蓝牙需要断开连接
              await model.device!.disconnect();
            }
            if (model.device != null) {
              // 连接蓝牙
              await model.device?.connect();
            }
            // use you function
            //Get.to(() => OperatePage(), arguments: model);
            //Get.toNamed("/operate", arguments: model);
          }catch(e){
            // ignore: avoid_print
            print("connect = $e");
            logic.scan(state.bleName);
          }
        },
      ).show(context);
    }
  }
}

