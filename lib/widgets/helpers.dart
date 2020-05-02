import 'package:flutter/material.dart';



// class CenterHorizontal extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return null;
//   }
// }

final Function HorizontalCenter = ({Widget child}) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    child
                  ]);