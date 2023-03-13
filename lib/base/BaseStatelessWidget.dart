import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class BaseStatelessWidget extends StatelessWidget with Component {
  // final Key? key;

  BaseStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context);


  Widget showIcon({required String name, double size = 20, Color? color}) {
    return SvgPicture.asset(
      name,
      width: size,
      height: size,
      color: color,
    );
  }



  buttonStyle(
      {MaterialColor backgroundColor = AppColors.primary,
      Color? borderColor,
      double? borderWidth,
      double borderRadius = 8}) {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          // side: borderWidth==null?BorderSide(
          //   width: 0
          // ): BorderSide(
          //   color: borderColor!,
          //   width:  borderWidth!,
          // )
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return backgroundColor;
        },
      ),
    );
  }
}
