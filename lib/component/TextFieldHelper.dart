import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/material.dart';

class TextFieldHelper {
  static clickableTextField(
      TextEditingController controller, String labelText, String hindText) {
    return TextField(
        enabled: false,
        controller: controller,
        decoration: InputDecoration(
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineColor)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(labelText),
          hintText: hindText,
          labelStyle: const TextStyle(color: AppColors.darkGray),
        ));
  }

  static TextFieldBordered(
      TextEditingController controller, String labelText, String hindText) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.lineColor)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(labelText),
          hintText: hindText,
          labelStyle: const TextStyle(color: AppColors.darkGray),
        ));
  }
}
