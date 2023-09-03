

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';
import 'package:chatapp/src/model/chat_model/chatmodel.dart';
import 'package:chatapp/src/utils/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../main.dart';

class ProfileScreen extends StatefulWidget {

   ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

 var list = Get.arguments;
 final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
              onPressed: () async {
                await Apis.signOut(context);

              },
              icon: Icon(Icons.logout),
              label: Text("Logout")),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .05,),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,

                          imageUrl:'${list.image}',
                          fit: BoxFit.fill,
                          // placeholder: (context, url) => CircularProgressIndicator(),
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
                                          // pick from gallery button
                                          ElevatedButton(
                                              onPressed: (){},
                                              child: Icon(Icons.add_photo_alternate,size: 80,)),

                                          // take picture from camera button
                                          ElevatedButton(
                                              onPressed: (){},
                                              child: Icon(Icons.camera_alt,size: 80,))
                                        ],
                                      )


                                    ],
                                  );
                                });
                          },
                          child: Icon(Icons.edit,color: Colors.blue,),
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: mq.height * .03,),
                  Text('${list.email}',style:TextStyle(color: Colors.black54,fontSize: 16),),
                  SizedBox(height: mq.height * .03,),
                  TextFormField(
                    initialValue: list.name,
                    onSaved: (value)=> Apis.me.name = value ?? ' ',
                    validator: (vales)=> vales != null && vales.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      hintText: 'Ex. Ravi sahu',
                      label: Text("Name")
                    ),
                  ),
                  SizedBox(height: mq.height * .02),
                  TextFormField(
                    initialValue: list.about,
                    onSaved: (value)=> Apis.me.about = value ?? ' ',
                    validator: (vales)=> vales != null && vales.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        hintText: 'type your about',
                        label: Text("About")
                    ),
                  ),
                  SizedBox(height: mq.height * .05),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 5
                    ),
                      onPressed: (){
                      if(_formkey.currentState!.validate()){
                        _formkey.currentState!.save();
                        Apis.updateUseInfo().then((value) {
                          Get.snackbar('Update',"Profile update Successfullty");
                        });
                        log('inside validater');
                      }
                      },
                      icon:Icon(Icons.update) ,
                      label:  Text("Update"),

                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
