import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Constants {
  static int GUEST_TIMER_FOR_PAYMENT=  24;


   static final String LISTING_NOTIFICATION = "listing";
   static final String LISTING_REJECT_NOTIFICATION = "listing_reject";
   static final String HOST_REJECT_NOTIFICATION = "host";
   static final String MESSAGING_NOTIFICATION = "conversation";
   static final String BOOKING_NOTIFICATION = "booking";
   static final String WITHDRAWAL_NOTIFICATION = "withdrawal";
   static final String REVIEW_NOTIFICATION = "review";


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

  static showFailedToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
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
       DateTime date = DateTime.parse(dateTime).toLocal();
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
