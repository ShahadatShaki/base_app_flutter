import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static String AUTH_KEY = "AUTH_KEY";
  static String USER_ID = "USER_ID";
  static String IS_LOGIN = "IS_LOGIN";

  static getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? s =  prefs.getString(key);
    if(s==null){
      return "";
    }else{
      return s;
    }
  }

  static putString(String key, String? value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value??"");
  }

  static getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool? b =  prefs.getBool(key);

    if(b==null){
      return false;
    }else{
      return b;
    }
  }


  static putBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int? s =  prefs.getInt(key);

    if(s==null){
      return 0;
    }else{
      return s;
    }
  }

  static putInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);

  }

  static getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static putDouble(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static var userId;
  static void initData() async {
    userId = await getString(USER_ID);
  }
}