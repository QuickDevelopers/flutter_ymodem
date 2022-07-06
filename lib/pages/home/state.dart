import 'dart:async';


import 'package:get/get.dart';

import '../../model/ble_model.dart';
import '../../widgets/load_state.dart';


class HomeState {

  late RxList<BleModel> bleList;

  late Rx<LoadState> loadState;

  late StreamSubscription? subscription;

  late String bleName = "xxx";

  HomeState() {
    // 默认加载中...
    bleList = <BleModel>[].obs;
    //bleScanList = <String>[].obs;
    // 默认加载中...
    loadState = LoadState.State_Loading.obs;
  }
}