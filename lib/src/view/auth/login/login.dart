import 'package:flutter/material.dart';

import '../../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
           ElevatedButton.icon(onPressed: (){},
             style: ElevatedButton.styleFrom(elevation: 4),
             icon: Image.asset('images/google.png',width:50,height: 25,),
           label: Text("Signin with Google",style: TextStyle(color: Colors.blueGrey,fontSize: 16),),)
          ],
        ),
    );
  }
}
