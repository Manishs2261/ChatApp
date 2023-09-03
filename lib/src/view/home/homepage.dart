



import 'dart:developer';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfINfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Chat App"),

        leading: Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            Get.toNamed(RoutesName.profileScreen,arguments: Apis.me);
          }, icon: Icon(Icons.more_vert)),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {


          },
          child: Icon(Icons.add),
        ),
      ),

      body: StreamBuilder(
        stream:  Apis.getAllUsers(),
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
                     // print("mansih ${list[index].image}");

                      return Card(
                        color: Colors.blue,
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: mq.width * .01,vertical: 3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(

                        // leading: CircleAvatar(child: Image.network(list[index].image.toString()),),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .3),
                            child: CachedNetworkImage(
                              width: mq.height * .055,
                              height: mq.height * .055,

                              imageUrl:'${list[index].image}',
                             // placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              CircleAvatar(child: Icon(CupertinoIcons.person),),
                            ),
                          ),


                          title: Text("${list[index].name}"),
                          subtitle: Text("${list[index].about}",maxLines: 1,),
                         // trailing: Text("12:00 pm",style: TextStyle(color: Colors.black54),),
                          trailing: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
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
