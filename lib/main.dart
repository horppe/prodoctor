//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:practiceapp/screens/home/home.dart';
import 'package:practiceapp/screens/login/login.dart';
import 'package:practiceapp/screens/send_money.dart';
import 'package:practiceapp/screens/signup/signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Closes Keyboard when user taps anywhere without focus
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "SignUp",
      onGenerateRoute: (RouteSettings settings) {
        var routeName = settings.name;
        switch(routeName){
          case "SendMoney": return MaterialPageRoute(builder: (BuildContext context) {
            return SendMoney();
          });

          case "Home": return MaterialPageRoute(builder: (BuildContext context) {
            return Home();
          });


          case "Login": return MaterialPageRoute(builder: (BuildContext context) {
            return Login();
          });

          case "SignUp": return MaterialPageRoute(builder: (BuildContext context) {
            return SignUp();
          });

          default: return MaterialPageRoute( builder: (BuildContext context) {
            return SendMoney();
          });
        }
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        fontFamily: 'CircularStd'
      ),
    //  home: // Start Screen Widget
    )
    );
  }
}