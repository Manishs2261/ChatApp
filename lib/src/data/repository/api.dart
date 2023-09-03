


import 'dart:developer';
import 'dart:io';

import 'package:chatapp/src/model/chat_model/chatmodel.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/utils/utils.dart';

class Apis{

  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //to return current user
  static User get user => auth.currentUser!;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // fpr storing self   `information
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for checking if user exists or not?
  static Future<bool> userExists() async{
    return (await firestore.collection('users').doc(auth.currentUser!.uid).get()).exists;
  }

  //for creating a new user
  static Future<void> createUser() async{

    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final chatmodel = ChatModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email,
      about: 'hey i am using chat app',
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: ''
    );

    return await firestore.collection('users').doc(user.uid).set(chatmodel.toJson());
  }

  // for getting all user from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }

static late ChatModel me;

  //for store self information
  static Future<void> getSelfINfo() async{
     await firestore.collection('users').doc(user.uid).get().then((value) async {

       if(value.exists){
         me = ChatModel.fromJson(value.data()!);
         log('my data :${value.data()}');

       }else{
         await createUser().then((value){
           getSelfINfo();
         });
       }
     });
  }


  // for updating user form firestore database
  static Future<void> updateUseInfo() async{
    await firestore.collection('users').doc(user.uid).update({
      'name':me.name,
      'about':me.about,
    });
  }

  //update profile picture of user

  static Future<void> updateProfilePicture(File file) async{
    //getting image file extenstion
    final ext = file.path.split('.').last;
    log('Extension :$ext');

    // storage file ref with path
    final ref = storage.ref().child('Profile_pictires/${user.uid}.$ext');

    // uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred :${p0.bytesTransferred / 1000} kb');
    });

    // updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('user').doc(user.uid).update(
        {
          'image': me.image
        });

  }





  // for sign out
  static signOut(BuildContext context)async{
    //sign out from app
    await  FirebaseAuth.instance.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value){
        // for hiding progress dialog
        Get.toNamed(RoutesName.loginScreen);
      });
    });

  }
}