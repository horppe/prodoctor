//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:practiceapp/blocs/cart_bloc.dart';
import 'package:practiceapp/blocs/product_bloc.dart';
import 'package:practiceapp/models/product.dart';
import 'package:practiceapp/screens/cart/cart.dart';
import 'package:practiceapp/screens/home/home.dart';
import 'package:practiceapp/screens/login/login.dart';
import 'package:practiceapp/screens/product_detail/product_detail.dart';
import 'package:practiceapp/screens/signup/signup.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp(){
    Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Closes Keyboard when user taps anywhere without focus
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }, child: MultiProvider(
        providers: [
          Provider<CartBloc>(create: (_) => CartBloc()),
          Provider<ProductBloc>(create: (_) => ProductBloc()),
        ],
          child: MaterialApp(
            
      //  title: 'Flutter Demo',
        initialRoute: "Login",
        onGenerateRoute: (RouteSettings settings) {
          var routeName = settings.name;
          switch(routeName){
            
            case "Home": return MaterialPageRoute(builder: (BuildContext context) {
              return Home();
            });

             case "ProductDetail": return MaterialPageRoute(builder: (BuildContext context) {
              return ProductDetail();
            });

            case "Cart": return MaterialPageRoute(builder: (BuildContext context) {
              return Cart();
            });


            case "Login": return MaterialPageRoute(builder: (BuildContext context) {
              return Login();
            });

            case "SignUp": return MaterialPageRoute(builder: (BuildContext context) {
              return SignUp();
            });

            default: return MaterialPageRoute( builder: (BuildContext context) {
              return Login();
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
          primarySwatch: Colors.blue,
          // canvasColor: Colors.transparent,
        ),
      //  home: // Start Screen Widget
      ),
    )
    );
  }
}
