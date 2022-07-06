import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

import '../../model/ble_model.dart';
import '../../widgets/load_state.dart';


class OtaState {

  late Rx<BleModel> bleModel;

  late Rx<LoadState> loadState;

  late BluetoothCharacteristic? otaCharacter;

  late Rx<String> fileName;

  late Rx<String> filePath;

  late Rx<double> progress;

  late StreamSubscription? subscription;

  late Rx<bool> disconnect;

  late bool isConnect = false;

  OtaState() {
    bleModel = BleModel().obs;
    // 默认加载中...
    loadState = LoadState.State_Loading.obs;
    fileName = "".obs;
    filePath = "".obs;
    progress = 0.0.obs;
    disconnect = false.obs;

  }
}
