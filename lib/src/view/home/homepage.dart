import 'package:chatapp/src/data/repository/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Chat App"),

        leading: Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
          Apis.signOut();

          },
          child: Icon(Icons.add),
        ),
      ),

      body:ListView.builder(
        itemCount: 16,
          padding: EdgeInsets.only(top: mq.height * .01),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index){

            return Card(
              color: Colors.blue,
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: mq.width * .01,vertical: 3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(

                leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
                title: Text("mansih"),
                subtitle: Text("sahu",maxLines: 1,),
                trailing: Text("12:00 pm",style: TextStyle(color: Colors.black54),),
              ),
            );

      }),
    );
  }
}
