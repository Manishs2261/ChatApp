import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../res/routes/routes_name.dart';



class SplashServices {

  void isLogin() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
    Timer(Duration(seconds: 3), () => Get.offNamed(RoutesName.loginScreen));


    // wait fo rvideo number 13
  }

}