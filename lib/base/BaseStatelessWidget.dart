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


}
