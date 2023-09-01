import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{



  static void showProgressBar(BuildContext context){

    showDialog(context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}