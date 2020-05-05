import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practiceapp/widgets/app_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Cart> with SingleTickerProviderStateMixin {
  initState() {
    super.initState();
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showAlert({List<String> messages, String title}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: AppBoldText(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: messages
                    .map<Widget>(
                        (m) => AppText(m, textStyle: TextStyle(fontSize: 14)))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: AppText('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: AppText(
            "Cart",
            textStyle: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        body: SafeArea(
            //  bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[]
                )
        )
    );
  }
}
