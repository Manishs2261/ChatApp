import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../data/repository/api.dart';
import '../../../model/chat_model/chatmodel.dart';
import '../../../utils/date_and_time/dateAndtime.dart';
import 'OptionItem.dart';

class MessageCardState extends StatefulWidget {
  final ChatModel chatModel;
  const MessageCardState({super.key, required this.chatModel});

  @override
  State<MessageCardState> createState() => _MessageCardStateState();
}

class _MessageCardStateState extends State<MessageCardState> {
  @override
  Widget build(BuildContext context) {
    bool isMe = Apis.user.uid == widget.chatModel.fromid;
    return InkWell(
      onLongPress: (){
        _showBottomSheet(isMe);
      },
      child: isMe    ? _greenMessage()
          : _blueMessage(),
    );

  }

  // sender or another user message
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

  // our or user message
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

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe){

    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20)
        )),
        builder:(_){
          return ListView(
            shrinkWrap: true,
            children: [

              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height * .015,
                    horizontal: mq.width * .4),
                decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(8)),),


              widget.chatModel.type == Type.text
                  ?     OptionItem(Icon(Icons.copy_all_outlined,color: Colors.blue,size: 26,), 'Copy Text', () {})
                  :   OptionItem(Icon(Icons.save,color: Colors.blue,size: 26,), 'Save image', () {}),

              if(widget.chatModel.type == Type.text && isMe)
                OptionItem(Icon(Icons.edit,color: Colors.blue,size: 26,), 'Edit Message', () {}),
              if(isMe)
                OptionItem(Icon(Icons.delete,color: Colors.red,size: 26,), 'Delete Message', () {}),
              OptionItem(Icon(Icons.remove_red_eye,color: Colors.blue,size: 26,), 'Sent At :', () {}),
              OptionItem(Icon(Icons.remove_red_eye,color: Colors.red,size: 26,), 'Read At : ', () {}),


            ],
          );
        });
  }
}