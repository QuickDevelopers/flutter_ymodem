import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/ble_model.dart';
import '../../widgets/circle_progress.dart';
import '../../widgets/tips_toast.dart';
import 'logic.dart';

// ignore: must_be_immutable
class OtaPage extends StatelessWidget {
  final logic = Get.put(OtaLogic());
  final state = Get.find<OtaLogic>().state;

  late BleModel model;

  // 第一次运行
  bool isFirst = true;

  OtaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(Get.arguments != null) {

      model = Get.arguments;

      state.fileName.value = "";
      state.filePath.value = "";
      state.progress.value = 0.0;

      // 接收蓝牙的通知
      logic.notice(context, model);
      logic.service(model);
      logic.receiveCallData(context, model);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ota UpGrade"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                // 执行点击事件操作
                try {
                  FilePickerResult? result =
                  await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['bin'],
                  );

                  if (result != null) {
                    state.fileName.value = result.files.first.name;
                    state.filePath.value = result.files.first.path!;
                  }

                  // ignore: avoid_print
                  print("你选择的为: ${state.fileName.value}");
                } catch (e) {
                  // ignore: avoid_print
                  print(e.toString());
                }
              },
              icon: const Icon(Icons.file_copy)),
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              if (state.fileName.value != "" && state.filePath.value != "") {
                logic.sendOtaStop();
                logic.exit(context, model);
              } else {
                logic.exit(context, model);
                Navigator.pop(context);
              }
            }),
      ),
      body: Obx(()=>
          connectWidget(context, model)
      ),
    );
  }

  Widget connectWidget(BuildContext context, BleModel model) {

    return
      Center(
        child: Column(
          children: [
            Container(
              height: 15,
            ),
            // 按钮
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width / 1.5,
              height: 55,
              color: const Color(0xFF454545),
              textColor: Colors.white,
              child: const Text('Start'),
              onPressed: () {
                if (state.fileName.value != "" &&
                    state.filePath.value != "") {
                  if(isFirst) {
                    logic.sendBegin();
                    logic.sendOtaStart();
                    isFirst = false;
                  }else{
                    Toast.toast(context,
                        msg: "Please do not click repeatedly!",
                        position: ToastPosition.bottom);
                  }

                } else {
                  Toast.toast(context,
                      msg: "Please select file!",
                      position: ToastPosition.bottom);
                }
              },
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                state.fileName.value != "" ? state.fileName.value:"Please select file",
                style: const TextStyle(
                    color: Color(0xFF334433),
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height / 2.5,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: CirclePercentProgress(
                    progress: state.progress.value,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height / 2.5,
                  height: MediaQuery.of(context).size.height / 2.5,
                  alignment: Alignment.center,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.blue, Colors.blue],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Text(
                      '${(state.progress.value * 100).toInt()}%',
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 始终保持在页面底部
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 55,
              color: const Color(0xFF454545),
              textColor: Colors.white,
              child: const Text('Stop Upgrade'),
              onPressed: () async {
                if (state.fileName.value != "" &&
                    state.filePath.value != "") {
                  logic.sendOtaStop();
                  logic.exit(context, model);
                } else {
                  Toast.toast(context,
                      msg: "Please select file!",
                      position: ToastPosition.bottom);
                }
              },
            )
          ],
        ),
      );
  }


}
