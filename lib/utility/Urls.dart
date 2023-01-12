class Urls {
  static String ROOT_URL_MAIN = "https://api.happihub.xyz/";

  static String Dami_Image =
      "https://static9.depositphotos.com/1719616/1205/i/600/depositphotos_12057489-stock-photo-sunflower-field.jpg";

  static getHeaders() async {

    String token = "\$2y\$10\$se80mJe/qjW/rTL9MUw7Q.pkJPiGQXMUy7HcTEdNd7jjPYIsZz4oy"; //Test token
    // String token = await SharedPref.getString(SharedPref.AUTH_KEY);
    int userId = 1; //Test User ID
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
}
