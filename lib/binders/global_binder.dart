import 'package:flutter_game/controller/global_controller.dart';
import 'package:get/get.dart';

class GlobalBinder extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalController(),);
  }
}