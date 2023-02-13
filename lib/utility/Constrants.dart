import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Constants {
  static showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static int totalDays(DateTime a) {
    return (a.year * 365) + (a.month * 30) + a.day;
  }

  static String calenderToString(DateTime dateTime, String format) {
     try {
       return  DateFormat(format).format(dateTime);
    } catch (e) {
      print(e);
      return "";
    };
  }

  static String calenderStingToString(String dateTime, String format) {
     try {
       return  DateFormat(format).format(stingToCalender(dateTime));
    } catch (e) {
      return "";
    }
  }
  static DateTime stingToCalender(String dateTime) {
     try {
       DateTime date = DateTime.parse(dateTime);
       return  date;
    } catch (e) {
      return DateTime.now();
    }
  }

  static String capitalizeWords(String text) {
    return text.split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
