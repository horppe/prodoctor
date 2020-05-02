import 'package:flutter/material.dart';

 const double defaultFontSize = 18;
 const TextStyle defaultTextStyle = TextStyle(
  fontFamily: 'Poppins'
 );

@immutable
class AppText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;
  const AppText(this.text, { 
    this.textStyle, 
    this.textAlign 
  });
  @override
  Widget build(BuildContext context) {
     
    return Text(text, 
      textAlign: textAlign, 
      style: TextStyle(fontSize: defaultFontSize)
      .merge(defaultTextStyle)
      .merge(textStyle), 
    );
  }
}




@immutable
class AppBoldText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;

  const AppBoldText(this.text, { 
    this.textStyle, 
    this.textAlign 
  });
  @override
  Widget build(BuildContext context) {
     
    return Text(text, 
      textAlign: textAlign, 
      style: TextStyle(fontWeight: FontWeight.bold,  fontSize: defaultFontSize)
        .merge(defaultTextStyle)
        .merge(textStyle), 
    );
  }
}