import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class OptionItem extends StatelessWidget {

  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const OptionItem(this.icon,this.name,this.onTap);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .025),
        child: Row(
          children: [
            icon,
            Flexible(child: Text('     ${name}',style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              letterSpacing: .05,
            ),))
          ],
        ),
      ),
    );
  }
}