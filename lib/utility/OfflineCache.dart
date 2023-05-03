import 'package:json_store/json_store.dart';

class OfflineCache {

  static String USER_PROFILE = "USER_PROFILE";

  static getOffline(String fileName) async {
    JsonStore jsonStore = JsonStore();
    Map<String, dynamic>? json = await jsonStore.getItem(fileName);
    return json;
  }

  static saveOfflineJson(String fileName, var json) async {
    try {
      JsonStore jsonStore = JsonStore();
      var data  = await jsonStore.setItem(fileName, json);
      int i=0;
    } catch (e) {
      print(e);
    }
  }

  static clearData() {
    try {
      JsonStore jsonStore = JsonStore();
      jsonStore.clearDataBase();
    } catch (e) {
      print(e);
    }
  }
}
