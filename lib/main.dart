import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/src/res/routes/routes.dart';
import 'package:chatapp/src/view/splashScreen/splashscren.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get.dart';

//globel object for accessing device scren size
late Size  mq;
void main() {
  // for binding a android 13 version
  WidgetsFlutterBinding.ensureInitialized();
  //for splash screen opne full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // for setting orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value) {


    //for initializ a firebase
    _initializerFirebase();
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       appBarTheme: AppBarTheme(
         centerTitle: true,
         elevation: 3,
       ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
        getPages: AppRoutes.appRoutes()
      //HomePage(),
    );
  }
}

_initializerFirebase()async{

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Your channel description',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'chat app for you',

  );
  print(result);

}


