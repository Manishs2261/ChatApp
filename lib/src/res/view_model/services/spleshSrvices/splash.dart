import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../routes/routes_name.dart';

class SplashServices {

  void isLogin() {
    Timer(Duration(seconds: 3), () => Get.toNamed(RoutesName.loginScreen));
  }

}