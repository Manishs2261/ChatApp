import 'package:chatapp/src/res/routes/routes_name.dart';
import 'package:chatapp/src/view/ChatScreen/chat_Screen.dart';
import 'package:chatapp/src/view/auth/login/login.dart';
import 'package:chatapp/src/view/home/homepage.dart';
import 'package:chatapp/src/view/profil_screen/profilescreen.dart';
import 'package:chatapp/src/view/view_profile_screen/view_profile_screen.dart';
import 'package:get/get.dart';

class AppRoutes{

  static appRoutes() =>[

    GetPage(name: RoutesName.splashscreen,
        page: ()=> LoginScreen(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),

    GetPage(name: RoutesName.loginScreen,
        page: ()=> LoginScreen(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),


    GetPage(name: RoutesName.homepage,
        page: ()=> HomePage(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),


    GetPage(name: RoutesName.profileScreen,
        page: ()=> ProfileScreen(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),

    GetPage(name: RoutesName.chatScreen,
        page: ()=> ChatScreen(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),

    GetPage(name: RoutesName.viewprofilescreen,
        page: ()=> ViewProfileScreen(),transitionDuration: Duration(milliseconds: 250),transition: Transition.leftToRightWithFade),




  ];
}