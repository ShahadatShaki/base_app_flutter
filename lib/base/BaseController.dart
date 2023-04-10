import 'package:get/get.dart';

class BaseController extends GetxController {

  var apiCalled = false.obs;
  var error = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  bool hasMoreData = true;



}
