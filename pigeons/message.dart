import 'package:pigeon/pigeon.dart';


class YmodemRequest{
  int? current;
  int? total;
  List? data;
  String? msg;
}


class YmodemResponse{
  // current status
  String? status;
  // run
  String? operate;
  // file name
  String? filename;
  //file path
  String? filepath;
  // is stop
  bool? stop;
  // is start
  bool? start;
}



@HostApi()
abstract class YmodemRequestApi{

  YmodemRequest getMessage(YmodemResponse params);

}