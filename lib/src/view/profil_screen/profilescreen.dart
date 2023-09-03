

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: mq.width * .05),
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
                    onPressed: (){},
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
                onPressed: (){},
                icon:Icon(Icons.update) ,
                label:  Text("Update"),

            )
          ],
        ),
      ),
    );
  }
}
