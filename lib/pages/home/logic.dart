import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import '../../model/ble_model.dart';
import '../../utils/utils.dart';
import '../../widgets/load_state.dart';
import 'state.dart';

class HomeLogic extends GetxController {

  final HomeState state = HomeState();

  FlutterBlue flutterBlue = FlutterBlue.instance;

  // 减速前的数组
  List<String> bleScanList = [];

  // please input your project device name
  String defaultName = "XXXX";

  // 扫描蓝牙列表
  scan(String name){
    // 停止蓝牙扫描
    stop();

    if(state.bleList.isNotEmpty){
      state.bleList.clear();
    }

    if(bleScanList.isNotEmpty){
      bleScanList.clear();
    }

    flutterBlue.startScan(timeout: const Duration(seconds: 10));

    state.subscription = flutterBlue.scanResults.listen((results) {

      for(ScanResult m in results){
        // 增加了去掉重复的数据
        // 并增加了单独显示设备的数据
        //if(m.device.name != "" && m.device.name.contains(defaultName) || m.device.name.contains("update")) {
        final address = Utils.instance.mac(m,m.device.name);
        // 这里改成Set效果一样
        if(!bleScanList.contains(address)) {
          var model = BleModel();
          model.name = m.device.name;
          model.mac = address;
          model.select = false;
          model.rssi = m.rssi.toInt();
          model.device = m.device;
          bleScanList.add(address);
          state.bleList.add(model);
          state.loadState.value = LoadState.State_Success;
        }
      }
    });

    if (state.bleList.isEmpty){
      state.loadState.value = LoadState.State_Empty;
    }
  }


  // 停止扫描蓝牙
  stop(){
    flutterBlue.stopScan();
  }

  @override
  void onClose() {
    super.onClose();

    if(state.subscription != null) {
      state.subscription!.cancel();
      state.subscription = null;
    }

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
    if(state.subscription != null) {
      state.subscription!.cancel();
      state.subscription = null;
    }
  }
}
