import 'package:flutter/material.dart';
import 'package:practiceapp/utils/dimensions.dart';

class Header extends StatelessWidget{

  String headerText;
  Function onBackPress;
  IconData iconData;

  Header(this.headerText, this.iconData, this.onBackPress);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
              constraints: BoxConstraints( minHeight: Dimensions.getHeight("8", context)),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                         
                        ),
                        constraints: BoxConstraints( minHeight: 50 ),
                        child: Center(

                            child: Text(

                              headerText, style: TextStyle(fontSize: 15,fontFamily: "CircularStd-Bold", fontWeight: FontWeight.w700, letterSpacing: .5))
                        ),
                      ),
                    ),
                    

                  ]
              ),
            );
  }
}