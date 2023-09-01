import 'dart:developer';
import 'dart:io';

import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:chatapp/src/utils/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  //for use goodle sign in
  _handleGoogleBtnClick(){
    Utils.showProgressBar(context);
    _signInWithGoogle().then((user){
      Navigator.pop(context);
  if(user!= null){
    log('\nUser${user.user}');
    log('\nUser adisionalinfo${user.additionalUserInfo}');
    Get.offNamed(RoutesName.homepage);
  }

    });
  }

    Future<UserCredential?> _signInWithGoogle() async {

    try{

      //for no internet connection
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);

    }catch(e){

      log('\n _signInWithGoogle : $e');
      print("mansih");

      Get.snackbar("Connection Error", "check your Internet Connection");
      return null;
    }
    }







  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Chat App",style: TextStyle(fontSize: 40),),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image(image: AssetImage( 'images/chaticon.png')),
            ),
            SizedBox(height: mq.height * .1,),
           ElevatedButton.icon(onPressed: (){
           _handleGoogleBtnClick();
           },
             style: ElevatedButton.styleFrom(elevation: 4,),
             icon: Image.asset('images/google.png',width:50,height: 25,),
           label: Text("Signin with Google",style: TextStyle(color: Colors.blueGrey,fontSize: 16),),)
          ],
        ),
    );
  }
}
