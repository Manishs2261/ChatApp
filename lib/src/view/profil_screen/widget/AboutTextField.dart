import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/api.dart';

class AboutTextField extends StatelessWidget {
  const AboutTextField({
    super.key,
    required this.list,
  });

  final  list;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: list.about,
      onSaved: (value)=> Apis.me.about = value ?? ' ',
      validator: (vales)=> vales != null && vales.isNotEmpty ? null : 'Required Field',
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          hintText: 'type your about',
          label: Text("About")
      ),
    );
  }
}