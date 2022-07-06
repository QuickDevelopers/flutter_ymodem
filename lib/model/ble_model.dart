import 'package:flutter_blue/flutter_blue.dart';

class BleModel{

  // 蓝牙名称
  late String? name = "";

  // 蓝牙地址
  late String? mac = "";

  // 蓝牙信号值
  late int? rssi;

  // 是否选择
  late bool? select;

  // 蓝牙设备
  late BluetoothDevice? device;

  // 温度数据
  late String? temp;

  // 单位数据
  late String? unit = "1";

  // 状态数据1
  late String? status1 = "";

  // 状态数据2
  late String? status2 = "";

  // 状态数据3
  late String? status3 = "";

  // 状态数据4
  late String? status4 = "";

  // 设备信息
  late String? info = "";

  // ota数据
  late String? ota = "";

  // ota
  late BluetoothCharacteristic? otaCharacter;

  late BluetoothDeviceState deviceState;

  // 默认连接是断开的
  late bool connect = false;



}