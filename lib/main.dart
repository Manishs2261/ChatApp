import 'package:chatapp/src/view/auth/login/login.dart';
import 'package:chatapp/src/view/home/homepage.dart';
import 'package:flutter/material.dart';

//globel object for accessing device scren size
late Size  mq;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: LoginScreen()
      //HomePage(),
    );
  }
}


