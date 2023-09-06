



import 'dart:developer';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/model/chat_model/chatmodel.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:chatapp/src/utils/date_and_time/dateAndtime.dart';
import 'package:chatapp/src/view/home/widget/image_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../main.dart';
import '../../model/user_model/usermodel.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    // for store=ing all users
  List<UserModel>_list =[];
  // for storing searched item
  final List<UserModel>_isSerchList = [];
  // for storing search status
  bool _isSearching = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Apis.getSelfINfo();
    Apis.getSelfINfo();

    // for updating user active status accoding to lifecycle events
    //resumw -- active or online
    // pause - inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message){
      log('Message :$message');

      if(Apis.auth.currentUser != null){
        if(message.toString().contains('resume')) Apis.updateActiveStatus(true);
        if(message.toString().contains('pause')) Apis.updateActiveStatus(false);
      }

      return Future.value(message);
    });
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
                _list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

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

class CahtUserCard extends StatefulWidget {

   final UserModel chat;

  const CahtUserCard({
    super.key,
    required this.chat,
  });

  @override
  State<CahtUserCard> createState() => _CahtUserCardState();
}

class _CahtUserCardState extends State<CahtUserCard> {

  //last message info (if null --> o message)
  ChatModel? _chatModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * .01,vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){
          Get.toNamed(RoutesName.chatScreen,arguments: widget.chat);
        },
        child: StreamBuilder(
          stream: Apis.getLastMessage(widget.chat),
          builder: (context,snapshot){

            final data  = snapshot.data?.docs;
            final list = data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty){
              _chatModel = list[0];
            }
            return  ListTile(

              // leading: CircleAvatar(child: Image.network(list[index].image.toString()),),
              leading: InkWell(
                onTap: (){
                  showDialog(context: context, builder: (_)=>ImageDialog(userModel: widget.chat));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,

                    imageUrl:'${widget.chat.image}',
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        CircleAvatar(child: Icon(CupertinoIcons.person),),
                  ),
                ),
              ),


              title: Text("${widget.chat.name}"),
              subtitle: Text(
                _chatModel!= null
                ? _chatModel!.type == Type.image
                         ? 'image'
                        : _chatModel!.msg.toString()
                    : widget.chat.about.toString(),
                     maxLines: 1,),
              // trailing: Text("12:00 pm",style: TextStyle(color: Colors.black54),),


                // last message time
              trailing: _chatModel == null
              ? null  // show nothing when no messages is send
              : _chatModel!.read!.isEmpty && _chatModel!.fromid != Apis.user.uid
              ?
              // show for unread message
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10)
                ),
              )
                  : Text(MyDataUtils.getLastMessageTime(context: context, time: _chatModel!.send.toString()),
                style: TextStyle(color: Colors.black54),)
            );
          },
        )
      ),
    );
  }
}
