import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/repository/api.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({
    super.key,
    required GlobalKey<FormState> formkey,
  }) : _formkey = formkey;

  final GlobalKey<FormState> _formkey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
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

    );
  }
}