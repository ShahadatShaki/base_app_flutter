import 'package:base_app_flutter/pages/ConversationPage.dart';
import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/utility/Constrants.dart';

class NotificationClickHandler {

  static getIntentByType(String type, String id) {

    if (type.toLowerCase() == Constants.BOOKING_NOTIFICATION) {
      return ConversationPage(id: id);
      // intent = Intent(context, ChatActivity::class.java)
      // intent.putExtra(Constants.INTEND_ID, id)
    } else if (type.toLowerCase() == Constants.WITHDRAWAL_NOTIFICATION) {
      // intent = Intent(context, RedeemHistoryActivity::class.java)
      // intent.putExtra(Constants.INTEND_ID, id)
    } else if (type.toLowerCase() == Constants.MESSAGING_NOTIFICATION) {
      // intent = Intent(context, ChatActivity::class.java)
      // intent.putExtra(Constants.INTEND_DATA, id)
    } else if (type.toLowerCase() == Constants.LISTING_NOTIFICATION) {
      // intent = Intent(context, HostHomePage::class.java)
      // intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
      // intent.putExtra("tab", "listing")
    } else if (type.toLowerCase() == Constants.REVIEW_NOTIFICATION) {

      // if (SharedPref.getBoolean(SharedPref.Key.CURRENT_ROLL_HOST)) {
      //   intent = Intent(context, HostHomePage::class.java)
      //   intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
      // } else {
        // intent = Intent(context, BookingHistoryGuestActivity::class.java)
      // }

    } else if (type.toLowerCase() == Constants.LISTING_REJECT_NOTIFICATION) {
      return null;
    } else if (type.toLowerCase() == Constants.HOST_REJECT_NOTIFICATION) {
      return null;
    } else {
      return SplashScreen();
    }

  }
}
