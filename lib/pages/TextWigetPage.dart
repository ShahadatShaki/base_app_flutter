import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/pages/ListItemPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/SharedPref.dart';


class TextWigetPage extends StatelessWidget {
  TextWigetPage({Key? key}) : super(key: key);

  initState(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text(
            "Welcome to the Travela Flutter Application",
            style: TextStyle(fontSize: 20),
          ),
        )
    );
  }

}
