import 'package:dio/dio.dart';

class Urls {
  // static String ROOT_URL_MAIN = "https://api.travela.xyz/api/";
  static String ROOT_URL_MAIN = "api.travela.world";

  static String Dami_Image =
      "https://static9.depositphotos.com/1719616/1205/i/600/depositphotos_12057489-stock-photo-sunflower-field.jpg";

  static getHeaders() async {
    String token =
        "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGkudHJhdmVsYS53b3JsZFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTY3NDAzMjMyNSwiZXhwIjoxNzA1NTY4MzI1LCJuYmYiOjE2NzQwMzIzMjUsImp0aSI6Ik8zZzJWR1Z1S0hLUEN3aHUiLCJzdWIiOjYsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.a8GRkVYisAgPikSGCpirGnAgUfpunhREvUNNh-llFPQ"; //Test token
    // String token = await SharedPref.getString(SharedPref.AUTH_KEY);
    int userId = 6; //Test User ID
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
      baseUrl: Urls.ROOT_URL_MAIN,
      headers: await Urls.getHeaders(),
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    Dio dio = Dio(options);

    return dio;
  }
}
