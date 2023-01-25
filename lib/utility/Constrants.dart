import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  static showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static int totalDays(DateTime a) {
    return (a.year * 365) + (a.month * 30) + a.day;
  }
}
