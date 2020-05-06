import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practiceapp/services/auth.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:practiceapp/widgets/app_button.dart';
import 'package:practiceapp/widgets/app_text.dart';
import 'package:practiceapp/widgets/helpers.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  String imageUri =
      "https://images2.minutemediacdn.com/image/upload/c_crop,h_1414,w_2101,x_20,y_0/v1565279671/shape/mentalfloss/578211-gettyimages-542930526.jpg?itok=Le7nMAZH";
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  ScrollController _scrollController = new ScrollController();
  final _formkey = GlobalKey<FormState>();
  bool logginIn = false;
  @override
  void didChangeMetrics() {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0.0;
    isKeyboardOpen
        ? _scrollController.animateTo(100,
            duration: Duration(milliseconds: 400), curve: Curves.easeOut)
        : _scrollController.animateTo(0,
            duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    super.didChangeMetrics();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  showAlert ({List<String> messages, String title}) {
    
    showDialog(context: context, builder: (BuildContext context) {
        
        return AlertDialog(
          title: AppBoldText(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: messages.map<Widget>((m) => AppText(m, textStyle: TextStyle(fontSize: 14))).toList(),
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

  login() async {
    if(_formkey.currentState.validate()){
      setState(() {
        logginIn = true;
      });
      String email = emailController.text.toLowerCase();
      String password = passwordController.text;
      AuthService authService = AuthService();
      FirebaseUser user = await  authService.signWithEmailandPassword(email: email, password: password);
      setState(() {
          logginIn = false;
        });
      if(user != null){         
        Navigator.of(context).pushNamedAndRemoveUntil("Home", (Route<dynamic> route) => route.settings.name == "Home");
      } else {
         
        showAlert(title: "Error", messages: ["An error occured while attempting to login. \nPlease try again."]);
      }
      
    }
  }

  Widget renderPasswordField(String labelText,
      {FocusNode focusNode,
      TextEditingController controller,
      bool showPassword = false,
      FormFieldValidator validator,
      Function onTapEye}) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          decoration:
              BoxDecoration(color: Color(CustomColorData.inputBacground)),
          child: TextFormField(
            obscureText: !showPassword,
            validator: validator,
            controller: controller,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(fontSize: 14).merge(defaultTextStyle),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.black54),
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dimensions.getHeight(".5", context),
                  horizontal: Dimensions.getWidth("3", context)),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
        Positioned(
          right: 5,
          child: GestureDetector(
              onTap: onTapEye,
              child: Icon(
                showPassword ? Ionicons.md_eye : Ionicons.md_eye_off,
                size: 18,
                color: Colors.black45,
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formkey,
        child: Container(
          constraints: BoxConstraints.expand(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.getWidth("4", context)),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if(Navigator.of(context).canPop()){
                                    Navigator.of(context).pop();
                                }
                              },
                              child: Icon(Entypo.cross,)
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            
                            SizedBox(height: 10),
                            AppText(
                              "Welcome!",
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            AppText("Log in to your account",
                                textAlign: TextAlign.center,
                                textStyle: TextStyle(
                                  fontSize: 13,
                                )),
                            SizedBox(
                              height: Dimensions.getHeight("2", context),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(CustomColorData.inputBacground)),
                              child: TextFormField(
                                controller: emailController,
                                 validator: (String str) {
                                  if (str.isEmpty) {
                                    return "Email cannot be left empty";
                                  } else {
                                    Pattern pattern =
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                            RegExp regex = new RegExp(pattern);
                                            if (!regex.hasMatch(str))
                                              return 'Please make sure your email address is valid';
                                  }
                                  return null;
                                },
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: 14)
                                    .merge(defaultTextStyle),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.getHeight(".5", context),
                                      horizontal:
                                          Dimensions.getWidth("3", context)),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                    child: renderPasswordField("Password",
                                        controller: passwordController,
                                        showPassword: showPassword,
                                        validator: (str) {
                                            if (str.isEmpty) {
                                              return "Password can't be empty";
                                            } else {
                                              if(str.length < 6)
                                                        return 'Password is too short';
                                            }
                                            return null;
                                        },
                                        onTapEye: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                })),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getHeight("2", context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                AppText(
                                  "Forgot your Password?",
                                  textStyle: TextStyle(
                                      fontSize: Dimensions.loginText,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.getHeight("2", context),
                            ),
                            PrimaryButton(
                              text: "Log in",
                              loading: logginIn,
                              onTap: () {
                                login();
                              },
                            ),
                            SizedBox(
                              height: Dimensions.getHeight("1", context),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'By continuing, you agree to our ',
                                  style: TextStyle(
                                          color: Colors.black,
                                          fontSize: Dimensions.loginText)
                                      .merge(defaultTextStyle),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
                controller: _scrollController,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: SizedBox(
                      width: Dimensions.getWidth("100", context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.getWidth("4", context),
                            vertical: 5),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.black45,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            AppBoldText(
                              "Don't have an account yet?",
                              textStyle:
                                  TextStyle(fontSize: Dimensions.loginText),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("SignUp");
                                // NavigatorState().reassemble();
                              },
                              child: AppBoldText(
                                "Create an Account here",
                                textStyle: TextStyle(
                                    fontSize: Dimensions.loginText,
                                    color: Color(0xFFFC4A1A)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
