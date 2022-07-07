# flutter_ymodem

support Android/iOS/Mac platform

## Getting Started


The demo contains all the usage methods methodChannel or pigeon

iOS has been tested.

Android please you try again.

use 

##### methodChannel

define

```dart

// define

var channel = const MethodChannel('com.flutter.guide.YModemChannel');

```

send ios/android data

```dart
// send ios/android data

channel.invokeMethod(
              "otaStart", {"fileName": state.fileName.value,"filePath":state.filePath.value, "otaStatus": q});

```

receive ios/android data  

```dart

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


```

##### use pigeon

define

```dart
YmodemRequestApi api = YmodemRequestApi();

```

send data

```dart
YmodemResponse response = YmodemResponse();

    response.status = "otaBegin";

    api.getMessage(response);
```

receive data and send data

```dart

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

```

#### update July 7 2022

1. Add macOS
2. Add pigeon

    please check logic_pigeon.dart code 


#### update july 6 2022

1. Data transfer between Android and IOS via MethodChannel has been completed
2. Please check the code for details
