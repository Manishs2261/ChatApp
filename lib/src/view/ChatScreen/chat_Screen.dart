import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/utils/date_and_time/dateAndtime.dart';
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
                      MaterialButton(onPressed: (){
                        if(_textContrroller.text.isNotEmpty){
                          Apis.sendingMessage(user, _textContrroller.text,Type.text);
                          _textContrroller.text = '';
                        }
                      },
                        minWidth: 0,
                      padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
                      shape: CircleBorder(),
                      color: Colors.green,
                      child: Icon(Icons.send,color: Colors.white,size: 28,),)
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

class MessageCardState extends StatefulWidget {
  final ChatModel chatModel;
  const MessageCardState({super.key, required this.chatModel});

  @override
  State<MessageCardState> createState() => _MessageCardStateState();
}

class _MessageCardStateState extends State<MessageCardState> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.chatModel.fromid
        ? _greenMessage()
        : _blueMessage();
  }
  
  Widget _blueMessage(){

    // update last read message if sender and receiver are different
    if(widget.chatModel.read!.isEmpty)
      {
        Apis.updateMessageReadStatus(widget.chatModel);
      }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.chatModel.type == Type.image ? mq.width * .0: mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: mq.height * .01),
            decoration: BoxDecoration(color: Color.fromARGB(255, 211, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),

            child: widget.chatModel.type == Type.text ?
                      Text('${widget.chatModel.msg}',style: TextStyle(fontSize: 15,color: Colors.black87),)
                          :
                      //show image
                      ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                      imageUrl:'${widget.chatModel.msg}',
                       placeholder: (context, url) => Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: CircularProgressIndicator(strokeWidth: 2,),
                       ),
                      errorWidget: (context, url, error) =>
                      Icon(Icons.image,size: 70,)
                      ),
                      ),
                            ),
                          ),
        Padding(
          padding:  EdgeInsets.only(right:mq.width *.03),
          child: Text('${MyDataUtils.getFormattedTiime(context: context, time: widget.chatModel.send.toString())}',
            style: TextStyle(fontSize: 13,color: Colors.black54),),
        ),
      ],
    );
  }
  
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // for adding some space
            SizedBox(width: mq.width * .04,),
            //doduble tick blue icon for message read

            Icon(Icons.done_all_rounded,color: Colors.blue,),
            // for adding some space
            SizedBox(width: 2,),

            //sead time
            Text(MyDataUtils.getFormattedTiime(context: context, time: widget.chatModel.send.toString()),
              style: TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.chatModel.type == Type.image ? mq.width * .0: mq.width * .04),
            margin: EdgeInsets.symmetric(horizontal: mq.width * .04,vertical: mq.height * .01),
            decoration: BoxDecoration(color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),

                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                )
            ),

            //show text
            child: widget.chatModel.type == Type.text ?
            Text('${widget.chatModel.msg}',style: TextStyle(fontSize: 15,color: Colors.black87),)
                :
                //show image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl:'${widget.chatModel.msg}',
                 placeholder: (context, url) => Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: CircularProgressIndicator(strokeWidth: 2,),
                 ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.image,size: 70,)
              ),
            ),

          ),
        ),
      ],
    );
  }
}

