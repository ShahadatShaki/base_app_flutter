import 'package:base_app_flutter/controller/NotificationClickController.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/pages/ConversationPage.dart';
import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/pages/host/HostHomePage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:get/get.dart';

class NotificationClickHandler {

  final NotificationClickController controller = Get.put(NotificationClickController());


  navigat(String type, String id) async {

    if (type.toLowerCase() == Constants.BOOKING_NOTIFICATION) {
      ConversationModel model = await controller.getConversationIdFromBooking(id);
      Get.to(()=> ConversationPage(id: model.id));

      // intent = Intent(context, ChatActivity::class.java)
      // intent.putExtra(Constants.INTEND_ID, id)
    } else if (type.toLowerCase() == Constants.WITHDRAWAL_NOTIFICATION) {
      // intent = Intent(context, RedeemHistoryActivity::class.java)
      // intent.putExtra(Constants.INTEND_ID, id)
    } else if (type.toLowerCase() == Constants.MESSAGING_NOTIFICATION) {
      // intent = Intent(context, ChatActivity::class.java)
      // intent.putExtra(Constants.INTEND_DATA, id)
      if(SharedPref.isHost){
        Get.offAll(()=> HostHomePage());
      }else{
        Get.offAll(()=> UserHomePage());
      }
      Get.to(()=> ConversationPage(id: id), );
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
