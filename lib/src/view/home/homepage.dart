



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

    // for store=ing all users
  List<ChatModel>_list =[];
  // for storing searched item
  final List<ChatModel>_isSerchList = [];
  // for storing search status
  bool _isSearching = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfINfo();
  }

  @override
  Widget build(BuildContext context) {
    print("new build");
    return GestureDetector(
      // for hiding keyboard when a tap is deected on screen
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // if search is on & back button is pressed then close search
        // or else simple close current scren on back button click
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = false;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(


          appBar: AppBar(
            title: _isSearching
                ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name, Email,.."
              ),
              autocorrect: true,
              autofocus: true,
              style: TextStyle(fontSize: 17,letterSpacing: 0.5),
              // when search text change then update search list
              onChanged: (value){
                //search logic
                _isSerchList.clear();
                for(var i in _list){
                  if(i.name!.toLowerCase().contains(value.toLowerCase()) ||
                      i.email!.toLowerCase().contains(value.toLowerCase())){

                    _isSerchList.add(i);
                  }else
                    {
                      setState(() {
                        _isSerchList;
                      });
                    }
                }
              },
            )
                :Text("Chat App") ,
            leading: Icon(CupertinoIcons.home),
            actions: [

              // for user search buttton
              IconButton(onPressed: (){
                 setState(() {
                   _isSearching = !_isSearching;
                 });
              }, icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),
              //  more feartures button
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
                _list = data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];

                if(_list.isNotEmpty)
                  {
                    return ListView.builder(
                        itemCount:_isSearching ? _isSerchList.length: _list.length,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                         // print("mansih ${list[index].image}");

                          return CahtUserCard(chat:_isSearching ? _isSerchList[index] : _list[index]);

                        });
                  }else
                    {
                      return Center(child: Text("No connection Found!",style: TextStyle(fontSize: 20),),);
                    }

              }



            },
          ),
        ),
      ),
    );
  }
}

class CahtUserCard extends StatelessWidget {

   final ChatModel chat;

  const CahtUserCard({
    super.key,
    required this.chat,
  });


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .01,vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){
          Get.toNamed(RoutesName.chatScreen,arguments: chat);
        },
        child: ListTile(

        // leading: CircleAvatar(child: Image.network(list[index].image.toString()),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,

              imageUrl:'${chat.image}',
             // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),


          title: Text("${chat.name}"),
          subtitle: Text("${chat.about}",maxLines: 1,),
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
      ),
    );
  }
}
