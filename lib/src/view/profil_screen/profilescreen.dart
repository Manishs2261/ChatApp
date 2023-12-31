import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/data/repository/api.dart';

import 'package:chatapp/src/utils/utils/utils.dart';
import 'package:chatapp/src/view/profil_screen/widget/AboutTextField.dart';
import 'package:chatapp/src/view/profil_screen/widget/NameTextField.dart';
import 'package:chatapp/src/view/profil_screen/widget/UpdateButton.dart';
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

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var list = Get.arguments;
  final _formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FloatingActionButton.extended(
              onPressed: () async {
                // for showing prograss dialog
                Utils.showProgressBar(context);

                await Apis.updateActiveStatus(false);
                // await Apis.signOut(context);

                //sing out from app
                await FirebaseAuth.instance.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //for hiding prograss dialog
                    Navigator.pop(context);

                    Apis.auth = FirebaseAuth.instance;

                    //for moving to home screen
                    Navigator.pop(context);
                    //replacing home screen with login screen
                    Get.toNamed(RoutesName.loginScreen);
                  });
                });
              },
              icon: Icon(Icons.logout),
              label: Text("Logout")),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ?
                          //local image
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          :
                          // image from server
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                imageUrl: '${list.image}',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          onPressed: () {
                            //bottom sheet for picking a profile picture for user
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                builder: (_) {
                                  return ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                        top: mq.height * .03,
                                        bottom: mq.height * .08),
                                    children: [
                                      Text(
                                        "Pick Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // pick from gallery button
                                          ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                log("imahe");
                                                // Pick an image.
                                                final XFile? image =
                                                    await picker.pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        imageQuality: 70);
                                                if (image != null) {
                                                  log('Image path :${image.path} -- - MImeType :${image.mimeType}');
                                                  setState(() {
                                                    _image = image.path;
                                                  });

                                                  Apis.updateProfilePicture(
                                                      File(_image!));
                                                  Navigator.pop(context);
                                                }
                                                // for hiding bottom sheet
                                              },
                                              child: Icon(
                                                Icons.add_photo_alternate,
                                                size: 80,
                                              )),

                                          // take picture from camera button
                                          ElevatedButton(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                log("imahe");
                                                // Pick an image.
                                                final XFile? image =
                                                    await picker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                if (image != null) {
                                                  log('Image path :${image.path} -- - MImeType :${image.mimeType}');
                                                  setState(() {
                                                    _image = image.path;
                                                  });
                                                  Apis.updateProfilePicture(
                                                      File(_image!));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 80,
                                              ))
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          color: Colors.white,
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Text(
                    '${list.email}',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  NameTextField(list: list),
                  SizedBox(height: mq.height * .02),
                  AboutTextField(list: list),
                  SizedBox(height: mq.height * .05),
                  UpdateButton(formkey: _formkey)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
