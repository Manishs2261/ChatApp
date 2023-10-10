import 'dart:convert';
import 'dart:developer';

import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/model/user_model/usermodel.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:chatapp/src/utils/date_and_time/dateAndtime.dart';
import 'package:chatapp/src/view/ChatScreen/widget/MessageCardState.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../model/chat_model/chatmodel.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  // for get data form Home screen 
  var user =Get.arguments;

  // for handling message text changes
  final TextEditingController _textContrroller = TextEditingController();


  // for storing all messages
  List<ChatModel>_list = [];

  // for storing value of showing or hiding emoji
  bool _showEmoji = false;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
  print("dtaa user ${user}");

    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          // if search is on & back button is pressed then close search
          // or else simple close current scren on back button click
          onWillPop: (){
            if(_showEmoji){
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            }else{
              return Future.value(true);
            }
          },

          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar() ,

            ),
            backgroundColor:  Color.fromARGB(255, 234, 248, 255),
            body:  Column(
              children: [

                Expanded(
                  child: StreamBuilder(
                   stream: Apis.getAllMessage(user),
                    builder: (context, snapshot) {

                      switch(snapshot.connectionState){
                      // if dats is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return SizedBox();
                      // if some or all data is  loaded then show
                        case ConnectionState.active:
                        case ConnectionState.done:
                          //
                            final data  = snapshot.data?.docs;

                          _list = data?.map((e) => ChatModel.fromJson(e.data())).toList() ?? [];


                          if(_list.isNotEmpty)
                          {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context,index){
                                  // print("mansih ${list[index].image}");

                                  return MessageCardState(chatModel: _list[index],);


                                });
                          }else
                          {
                            return Center(child: Text("say hi 👋",style: TextStyle(fontSize: 20),),);
                          }
                      }

                    },
                  ),
                ),

                //progress indecatoir for showing uploading
                if(_isUploading)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    child: CircularProgressIndicator(strokeWidth: 2,),
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
                              IconButton(onPressed: (){

                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _showEmoji = !_showEmoji;
                                });
                              },
                                  icon: Icon(Icons.emoji_emotions,color: Colors.blueAccent,)),

                              Expanded(child: TextField(
                                controller: _textContrroller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                onTap: (){
                                  if(_showEmoji)
                                  setState(() {
                                    _showEmoji = !_showEmoji;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Message...',
                                  helperStyle: TextStyle(color: Colors.blueAccent),
                                  border: InputBorder.none
                                ),
                              )),

                              // pick image from gallery button
                              IconButton(onPressed: () async {

                                final ImagePicker picker = ImagePicker();

                                //picking multiple images
                                final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

                                for(var i in images){
                                  setState(() {
                                    _isUploading = true;
                                  });
                                  log('Image path: ${i.path}');
                                  await Apis.sendChatImage(user, File(i.path));
                                  setState(() {
                                    _isUploading = false;
                                  });
                                }
                              },
                                  icon: Icon(Icons.photo,color: Colors.blueAccent,)),

                              // take image from camera button
                              IconButton(onPressed: () async {

                                final ImagePicker picker = ImagePicker();

                                //pick an image
                                final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 70);
                                if(image != null)
                                {
                                  setState(() {
                                    _isUploading = true;
                                  });
                                  log('Image path: ${image.path}');
                                  await Apis.sendChatImage(user, File(image.path));
                                  setState(() {
                                    _isUploading = false;
                                  });
                                }
                              },
                                  icon: Icon(Icons.camera_alt,color: Colors.blueAccent,)),
                              SizedBox(width: mq.width * .02,),
                            ],
                          ),
                        ),
                      ),
                      SendMessage(textContrroller: _textContrroller, user: user)
                    ],
                  ),
                ),


      // show emojis on keyboard emoji button click & vice versa
       if(_showEmoji)
      SizedBox(
          height: mq.height * .35,
          child: EmojiPicker(

          textEditingController: _textContrroller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
          config: Config(
          columns: 7,
          bgColor: Color.fromARGB(255, 234, 248, 255),
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894

          ),
          ),
      )

              ],
            ),
          ),
        ),

      ),
    );
  }

  //App bar widget
  Widget _appBar(){
    return InkWell(
      onTap: (){
        Get.toNamed(RoutesName.viewprofilescreen,arguments: user);
      },
      child: StreamBuilder(
        stream: Apis.getUserInfo(user),
        builder: (context,snapshot){

          final data = snapshot.data?.docs;
          final list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

          return  Row(
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

                  imageUrl: list.isNotEmpty ? '${list[0].image}' : '${user.image}',
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
                  Text(list.isNotEmpty ? list[0].name : user.name,style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500
                  ),),
                  // for adding some space
                  SizedBox(height: 3,),
                  // last seen time of user
                  Text(
                       list.isNotEmpty
                    ? list[0].isOnline!
                           ?'Online'
                           : MyDataUtils.getLastActiveTime(context: context, lastActive: list[0].lastActive.toString())
                           : MyDataUtils.getLastActiveTime(context: context, lastActive: user.lastActive)
                         ,style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500
                  ),)
                ],
              )
            ],
          );
        },
      )
    );
  }

  // bottom chat input field

}

class SendMessage extends StatelessWidget {
  const SendMessage({
    super.key,
    required TextEditingController textContrroller,
    required this.user,
  }) : _textContrroller = textContrroller;

  final TextEditingController _textContrroller;
  final  user;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: (){
      if(_textContrroller.text.isNotEmpty){
        Apis.sendingMessage(user, _textContrroller.text,Type.text);
        _textContrroller.text = '';
      }
    },
      minWidth: 0,
    padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
    shape: CircleBorder(),
    color: Colors.green,
    child: Icon(Icons.send,color: Colors.white,size: 28,),);
  }
}



