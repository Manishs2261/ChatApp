


import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:chatapp/src/model/chat_model/chatmodel.dart';
import 'package:chatapp/src/model/user_model/usermodel.dart';
import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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

    final userModel = UserModel(
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

    return await firestore.collection('users').doc(user.uid).set(userModel.toJson());
  }

  // for getting all user from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }

static late UserModel me;

  //for store self information
  static Future<void> getSelfINfo() async{
     await firestore.collection('users').doc(user.uid).get().then((value) async {

       if(value.exists){
         me = UserModel.fromJson(value.data()!);
       await  getFirebaseMessagingToken();
         // for setting user statud to active
         Apis.updateActiveStatus(true);
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

  ///********************* chat screen related apis********************

  // chats (colliection --> conversation_id (doc) --> message (collection) --> message (doc)
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(UserModel userModel){
    return firestore.collection('chats/${getConversationID(userModel.id)}/messages/')
        .orderBy('send',descending: true)
        .snapshots();
  }
  //for sending message
  static Future<void>sendingMessage(UserModel userModel,String msg,Type type)async{
    //message sending time (also used as id)
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    //message to send
    final ChatModel chatModel = ChatModel(
      told: userModel.id,
      msg: msg,
      read: '',
      type: type,
      fromid: user.uid,
      send: time,
    );

    final ref = firestore.collection('chats/${getConversationID(userModel.id)}/messages/');
    await ref.doc(time).set(chatModel.toJson()).then((value){
      sendPushNOtification(userModel,type == Type.text ? msg : 'image');
    });
  }

  // for update read status of messsage
  static Future<void> updateMessageReadStatus(ChatModel chatModel)async {

    firestore.collection('chats/${getConversationID(chatModel.fromid.toString())}/messages/').doc(chatModel.send)
    .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});

  }

  //get only last message of a specific chat

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel userModel){
    return firestore.collection('chats/${getConversationID(userModel.id)}/messages/')
    .orderBy('send',descending: true)
        .limit(1).snapshots();
  }


  // send chat image
  static Future<void> sendChatImage(UserModel userModel,File file)async{
    // getting image file extension
    final ext  = file.path.split('.').last;

    // storage file ref with path
    final ref = storage.ref().child('images/${getConversationID(userModel.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading image
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
      log('Data Transferred :${p0.bytesTransferred / 1000} kb');
    });

    // updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendingMessage(userModel,imageUrl,Type.image);

  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(UserModel userModel){
    return firestore.collection('users').where('id',isEqualTo: userModel.id).snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline)async{
    firestore.collection('users').doc(user.uid).update({
      'is_online':isOnline,
      'last_active':DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token':me.pushToken,
    });
  }


  // for getting firebase messaging (push  Notification)
 static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
static Future<void> getFirebaseMessagingToken()async{
  await fmessaging.requestPermission();
  await fmessaging.getToken().then((value){
    if(value != null){
      me.pushToken = value;
      log('push tocken$value');
    }

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
  });
}

//for sending push notification
static Future<void> sendPushNOtification(UserModel userModel,String msg) async {

  try{
    final body = {
      "to": userModel.pushToken,
      "notification": {
        "title": me.name, //our name should be send
        "body": msg,
        "android_channel_id": "chats",
      },
      // "data": {
      //   "some_data": "User ID: ${me.id}",
      // },
    };

    var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
          'key=AAAA8DBw2uk:APA91bGg7e9YbykaU2yNq60RdU1myJf-Bqg4CDw7E_Hc_UNr7BnO8gtTm0HnLKUDGfYGu0ne_nhsM5FjyiIWyAWqCLnIs0J0sqgkI-tCLXPasaMsxWaoN3AI2TA-M-RekWoD7eXeh7gR'
        },
        body: jsonEncode(body));
    log('Response status: ${res.statusCode}');
    log('Response body: ${res.body}');

  }catch(e){
          log('\n sendPushNotification : $e');
  }

}

}