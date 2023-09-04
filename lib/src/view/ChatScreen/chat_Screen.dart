import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  var user =Get.arguments;
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar() ,
        ),
        body:  Column(
          children: [

            Expanded(
              child: StreamBuilder(
               stream:  null,
                builder: (context, snapshot) {

                  switch(snapshot.connectionState){
                  // if dats is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      //return Center(child: CircularProgressIndicator(),);
                  // if some or all data is  loaded then show
                    case ConnectionState.active:
                    case ConnectionState.done:
                      //
                      // final data  = snapshot.data?.docs;
                      // _list = data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];

                  final _list = [];
                      if(_list.isNotEmpty)
                      {
                        return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: mq.height * .01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context,index){
                              // print("mansih ${list[index].image}");

                              return Text("Massage: ${_list[index]}");


                            });
                      }else
                      {
                        return Center(child: Text("say hi 👋",style: TextStyle(fontSize: 20),),);
                      }

                  }



                },
              ),
            ),

            // bottom type field code
            Padding(
              padding:  EdgeInsets.symmetric(vertical: mq.height * .01,horizontal: mq.width * .025),
              child: Row(
                children: [


                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          // emoji button
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,)),

                          Expanded(child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Message...',
                              helperStyle: TextStyle(color: Colors.blueAccent),
                              border: InputBorder.none
                            ),
                          )),

                          // pick image from gallery button
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.photo,color: Colors.blueAccent,)),

                          // take image from camera button
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.camera_alt,color: Colors.blueAccent,)),
                          SizedBox(width: mq.width * .02,),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(onPressed: (){},
                    minWidth: 0,
                  padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
                  shape: CircleBorder(),
                  color: Colors.green,
                  child: Icon(Icons.send,color: Colors.white,size: 28,),)
                ],
              ),
            )
          ],
        ),
      ),

    );
  }

  //App bar widget
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          //back button
          IconButton(
              onPressed: (){
                Get.back();
              },
              icon:Icon(Icons.arrow_back,color: Colors.black54,)),
          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,

              imageUrl:'${user.image}',
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  CircleAvatar(child: Icon(CupertinoIcons.person),),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name,style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 3,),
              Text('Last seen not available',style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500
              ),)
            ],
          )
        ],
      ),
    );
  }

  // bottom chat input field

}
