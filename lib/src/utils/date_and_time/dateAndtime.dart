import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDataUtils{
  //for getting formstted time from millisecondSincesEpochs String
  static String getFormattedTiime({required BuildContext context,required String time}){

    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // get last message time(used in chat user card)
static String getLastMessageTime({required BuildContext context,required String time}){

  final DateTime sentTime  = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
  final DateTime currentTime = DateTime.now();
  if(currentTime.day == sentTime.day && currentTime.month == sentTime.month && currentTime.year == sentTime.year)
    {
      return TimeOfDay.fromDateTime(sentTime).format(context);

    }
  return '${sentTime.day} ${_getMonth(sentTime)}';
}


// get month name from month no. or index
static  String _getMonth(DateTime date){
    switch(date.month){
      case 1:
        return 'jan';
      case 2 :
        return 'Feb';
      case 3 :
        return 'Mar' ;
      case 4 :
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return'Aug';
      case 9 :
        return'Sept';
      case 10:
        return 'Oct';
      case 11:
        return'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
}
}