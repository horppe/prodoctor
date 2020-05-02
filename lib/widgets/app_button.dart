import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:practiceapp/widgets/app_text.dart';


class PrimaryButton extends StatelessWidget {

  Function onTap;
  String text;

  PrimaryButton({this.onTap, this.text});
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 45 ,//Dimensions.getHeight("7", context),
      child: CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
          child: Container(
          decoration: BoxDecoration(color: Color(CustomColorData.inactiveBackground), borderRadius: BorderRadius.circular(3)),
          child: Center(child: AppBoldText(text, textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),),),
        ),
      ),
    );
  }
}