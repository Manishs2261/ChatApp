import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/model/user_model/usermodel.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class ImageDialog extends StatelessWidget {
  final UserModel userModel ;
  const ImageDialog({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      content: SizedBox(width: mq.width * .6, height:  mq.height * .35,
      child: Stack(
        children: [

//user profile picture

          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .25),
              child: CachedNetworkImage(
                width: mq.width * .5,
                fit: BoxFit.cover,
                imageUrl:'${userModel.image}',
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    CircleAvatar(child: Icon(CupertinoIcons.person),),
              ),
            ),
          ),
          //username
          Positioned(
            left: mq.width * .04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text('${userModel.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),
          //user info
          Align(
            alignment: Alignment.topRight,
              child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Get.toNamed(RoutesName.viewprofilescreen,arguments: userModel);
                  },
                  shape: CircleBorder(),
                  minWidth: 0,
                  padding: EdgeInsets.all(0),
                  child: Icon(Icons.info_outline,color: Colors.blue,size: 30,)))
        ],
      ),),

    );
  }
}

