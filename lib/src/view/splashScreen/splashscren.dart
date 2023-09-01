
import 'package:flutter/material.dart';

import '../../view_model/services/spleshSrvices/splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState

    splashServices.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: AssetImage('images/chaticon.png'),),),

    );
  }
}
