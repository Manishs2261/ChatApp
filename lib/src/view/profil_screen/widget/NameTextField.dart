import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/repository/api.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.list,
  });

  final  list;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: list.name,
      onSaved: (value)=> Apis.me.name = value ?? ' ',
      validator: (vales)=> vales != null && vales.isNotEmpty ? null : 'Required Field',
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          hintText: 'Ex. Ravi sahu',
          label: Text("Name")
      ),
    );
  }
}