

import 'package:chatapp/src/data/repository/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../main.dart';
import '../../model/chat_model/chatmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  List<ChatModel>list =[];

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

      body: StreamBuilder(
        stream: Apis.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {

          switch(snapshot.connectionState){
            // if dats is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator(),);
              // if some or all data is  loaded then show
            case ConnectionState.active:
            case ConnectionState.done:

            final data  = snapshot.data?.docs;
            list = data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];

            if(list.isNotEmpty)
              {
                return ListView.builder(
                    itemCount: list.length,
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
                          title: Text("${list[index].name}"),
                          subtitle: Text("${list[index].about}",maxLines: 1,),
                          trailing: Text("12:00 pm",style: TextStyle(color: Colors.black54),),
                        ),
                      );

                    });
              }else
                {
                  return Center(child: Text("No connection Found!",style: TextStyle(fontSize: 20),),);
                }

          }



        },
      ),
    );
  }
}
