import 'package:chatapp/src/model/chat_model/chatmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Apis{

  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //to return current user
  static User get user => auth.currentUser!;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  // for sign out
  static signOut()async{
    await  FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}