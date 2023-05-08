import 'package:base_app_flutter/controller/BookingController.dart';
import 'package:get/get.dart';

class NotificationClickIntentHandler {
  static const String LISTING_NOTIFICATION = "listing";
  static const String LISTING_REJECT_NOTIFICATION = "listing_reject";
  static const String HOST_REJECT_NOTIFICATION = "host";
  static const String MESSAGING_NOTIFICATION = "conversation";
  static const String BOOKING_NOTIFICATION = "booking";
  static const String WITHDRAWAL_NOTIFICATION = "withdrawal";
  static const String REVIEW_NOTIFICATION = "review";

  final BookingController controller = Get.put(BookingController());


  static getIntentByType(String type, String id) {
    // var type = type
    // val intent: Intent
    // if (type == null) {
    //   type = ""
    // }
    // if (type.toLowerCase() == Constants.BOOKING_NOTIFICATION) {
    //   intent = Intent(context, ChatActivity::class.java)
    //   intent.putExtra(Constants.INTEND_ID, id)
    // } else if (type.toLowerCase() == Constants.WITHDRAWAL_NOTIFICATION) {
    //   intent = Intent(context, RedeemHistoryActivity::class.java)
    //   intent.putExtra(Constants.INTEND_ID, id)
    // } else if (type.toLowerCase() == Constants.MESSAGING_NOTIFICATION) {
    //   intent = Intent(context, ChatActivity::class.java)
    //   intent.putExtra(Constants.INTEND_DATA, id)
    // } else if (type.toLowerCase() == Constants.LISTING_NOTIFICATION) {
    //   intent = Intent(context, HostHomePage::class.java)
    //   intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
    //   intent.putExtra("tab", "listing")
    // } else if (type.toLowerCase() == Constants.REVIEW_NOTIFICATION) {
    //
    //   if (SharedPref.getBoolean(SharedPref.Key.CURRENT_ROLL_HOST)) {
    //     intent = Intent(context, HostHomePage::class.java)
    //     intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
    //   } else {
    //     intent = Intent(context, BookingHistoryGuestActivity::class.java)
    //   }
    //
    // } else if (type.toLowerCase() == Constants.LISTING_REJECT_NOTIFICATION) {
    //   return null
    // } else if (type.toLowerCase() == Constants.HOST_REJECT_NOTIFICATION) {
    //   return null
    // } else {
    //   intent = Intent(context, SplashActivity::class.java)
    // }
    //
    // //GIT COMMIT TEST
    // return intent

    type ??= "";

    if (type.toLowerCase() == BOOKING_NOTIFICATION) {

    }
  }
}
