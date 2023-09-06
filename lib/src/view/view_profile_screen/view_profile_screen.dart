

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/utils/date_and_time/dateAndtime.dart';

import 'package:chatapp/src/utils/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../res/routes/routes_name.dart';

class ViewProfileScreen extends StatefulWidget {

  ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  var list = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),

        floatingActionButton:   Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Joined On: - ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            Text('${MyDataUtils.getLastMessageTime(context: context, time: list.createdAt,showYear: true)}',style:TextStyle(color: Colors.black54,fontSize: 16),),
          ],
        ),

        body:  Padding(
          padding:  EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(width: mq.width, height: mq.height * .05,),
                Stack(
                  children: [
                    // image from server
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .1),
                      child: CachedNetworkImage(
                        width: mq.height * .2,
                        height: mq.height * .2,

                        imageUrl:'${list.image}',
                        fit: BoxFit.cover,

                        errorWidget: (context, url, error) =>
                            CircleAvatar(child: Icon(CupertinoIcons.person),),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: (){

                          //bottom sheet for picking a profile picture for user
                          showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)
                                ),
                              ),
                              builder: (_) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      top: mq.height * .03,
                                      bottom: mq.height * .08
                                  ),
                                  children: [

                                    Text( "Pick Profile Picture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.w500),),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    )
                  ],
                ),

                SizedBox(height: mq.height * .03,),
                Text('${list.email}',style:TextStyle(color: Colors.black,fontSize: 16),),
                SizedBox(height: mq.height * .03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("About - ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    Text('${list.about}',style:TextStyle(color: Colors.black54,fontSize: 16),),
                  ],
                )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
