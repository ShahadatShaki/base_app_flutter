import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:dio/dio.dart';

class Urls {
  static String ROOT_URL_MAIN = "api.travela.world";
  // static String ROOT_URL_MAIN = "api.travela.xyz";

  // static var SOCKET_SERVER = "socket.travela.xyz";
  static var SOCKET_SERVER = "socket.travela.world";

  static var PUSHER_APP_ID = "travela";
  static var PUSHER_APP_SECRET = "travela123";
  static var PUSHER_APP_KEY = "travela";
  static var PUSHER_APP_CLUSTER = "mt1";

  static getHeaders() async {
    String token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkudHJhdmVsYS53b3JsZFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTY3NDAzMjMyNSwiZXhwIjoxNzA1NTY4MzI1LCJuYmYiOjE2NzQwMzIzMjUsImp0aSI6Ik8zZzJWR1Z1S0hLUEN3aHUiLCJzdWIiOjYsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.a8GRkVYisAgPikSGCpirGnAgUfpunhREvUNNh-llFPQ"; //Test token

   //Live Token
   //  String token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXBpLnRyYXZlbGEueHl6XC9hcGlcL2F1dGhcL2xvZ2luIiwiaWF0IjoxNjQ2NTYyNzk0LCJleHAiOjE2NzgwOTg3OTQsIm5iZiI6MTY0NjU2Mjc5NCwianRpIjoicElEU2t5elJpcXdWMGFTdSIsInN1YiI6NiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.mpieqEc7RUZdYV2glmTdoznXuEo7DG5qCGXUlSYIrUo"; //Test token
    // String token = await SharedPref.getString(SharedPref.AUTH_KEY);
    int userId = 6; //Test User ID
    SharedPref.putString(SharedPref.USER_ID, "6");
    // int userId = await SharedPref.getInt(SharedPref.USER_ID);

    Map<String, String> _headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
      'id': userId.toString(),
    };

    return _headers;
    // return object;
  }

  static getDio() async {
    var options = BaseOptions(
      baseUrl: "https://" + Urls.ROOT_URL_MAIN + "/",
      headers: await Urls.getHeaders(),
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    Dio dio = Dio(options);

    return dio;
  }
}
