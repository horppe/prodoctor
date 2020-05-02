//import 'dart:html';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practiceapp/models/friend.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/widgets/header.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:practiceapp/widgets/text_input_one.dart';
import 'package:practiceapp/widgets/text_input_select.dart';
import 'package:direct_select_flutter/direct_select_container.dart';

class SendMoney extends StatefulWidget {
  SendMoney({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  int index = 1;
  final _formkey = GlobalKey<FormState>();

  ScrollController scrollController = new ScrollController();

  Widget renderButton(Widget image, { bool isActive = false, String text = "", Function onTap }){
    return GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(

            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                decoration: BoxDecoration( border: Border.all( color: Color(CustomColorData.primary), width: 1 * .8), color:  Color( isActive ? CustomColorData.primary : CustomColorData.white), borderRadius: BorderRadius.circular(10)),
                constraints: BoxConstraints(minHeight: 100, minWidth: Dimensions.getWidth("40", context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    image,
                    Padding(padding: EdgeInsets.fromLTRB(0, Dimensions.getHeight("2", context), 0, 0)),
                    Text(text, style: TextStyle(fontWeight: FontWeight.w400, color: Color(isActive ? CustomColorData.white : CustomColorData.primary), letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }


  Widget renderSendWithBank () { 
    return Form(
                    key: _formkey,
                    child: Column(

                          children: <Widget>[
                            Padding(padding: EdgeInsets.symmetric(vertical: 15),),
                            TextInputOne(
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              label: "Amount",),
                            TextInputOne(
                                keyboardType: TextInputType.number,
                                label: "Enter Account Number"),
                            TextInputSelect(
                                label: "Select Bank",
                                values: <String>["Zenith Bank ***** 67857", "GTBank ***** 98422", "Wema Bank ***** 43217"],
                                ),
                            TextInputOne(
                                keyboardType: TextInputType.visiblePassword,
                                label: "For security purpose, please enter password",
                              obsureText: true,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal:  Dimensions.getWidth("5", context), vertical: Dimensions.getHeight("2", context) ),
                              child: GestureDetector(
                                onTap: () => {
                                  print("Hello World")
                                },
                                  child: Container(
                                  height: Dimensions.getHeight("7", context),
                                  decoration: BoxDecoration(color: Color(CustomColorData.buttonInactive), borderRadius: BorderRadius.circular(10)),
                                  child: Center(child: Text("Send Money", style: TextStyle(color: Colors.white, fontSize: 15))),
                                ),
                              ),
                            )

                          ],)
                    );
  }

  Widget renderFriend({
    String imageUri = "https://images2.minutemediacdn.com/image/upload/c_crop,h_1414,w_2101,x_20,y_0/v1565279671/shape/mentalfloss/578211-gettyimages-542930526.jpg?itok=Le7nMAZH", 
    String name, 
    String phone}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Image.network(
                            imageUri, 
                            width: Dimensions.getHeight("8", context), 
                            height:  Dimensions.getHeight("8", context),
                            fit: BoxFit.cover ,
                        )
                       // Image.memory(base64Decode(Friend.getAll()[0].imagePath)),
                    ),
                   SizedBox(width: Dimensions.getWidth("4", context)),
                    Expanded(

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                                      Text(name, style: TextStyle(fontFamily: "CircularStd", fontWeight: FontWeight.w700, letterSpacing: .5, fontSize: 18),),
                                      Text(phone, style: TextStyle(fontFamily: "CircularStd", letterSpacing: .5, fontSize: 16),),
                          ],
                        )
                    )
                  ],
                ),
    );
  }

  Widget renderSendToFriends(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth("2", context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: Dimensions.getHeight("7", context),
        decoration: BoxDecoration(color: Color(0xFFF8F8FA), borderRadius: BorderRadius.circular(5)),

            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,),
                  
                  child: FaIcon(FontAwesomeIcons.search, size: 18, color: Colors.black54,),
                ),
                Expanded(

                    child: TextField(
                      
                      decoration: InputDecoration(fillColor: Colors.blue, border: InputBorder.none, hintText: "Search"),
                    ),
                )
              ],
            ),
          ),
          SizedBox(height: Dimensions.getHeight("2", context)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth("3", context), vertical: Dimensions.getHeight("0.5", context)),
            child: Text("Tudo Contacts", style: TextStyle(fontFamily: "CircularStd", fontWeight: FontWeight.w700, letterSpacing: .5),),
          ),
          
          Container(
            constraints: BoxConstraints.expand(height: Dimensions.getHeight("60", context)),
            child: ListView(
             padding: const EdgeInsets.all(8),
              children: <Widget>[
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Akinwale Shaqs", phone: "080998465", imageUri: "https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg"),
                renderFriend(name: "Samson Oluokun", phone: "080998465", imageUri:  "https://images.pexels.com/photos/104827/cat-pet-animal-domestic-104827.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                renderFriend(name: "Sulaimon Adejo", phone: "080998465"),
                renderFriend(name: "Nike Nikes", phone: "080998465"),
                renderFriend(name: "Kemi To por", phone: "080998465"),
                renderFriend(name: "Samson Agba", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                renderFriend(name: "Sandra Ufemi", phone: "080998465"),
                
                SizedBox(height: Dimensions.getHeight("5", context),)
                
              ]
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: DirectSelectContainer(
        child: SafeArea(
          //  bottom: false,
          child: new SingleChildScrollView(

                    controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Header("Send Money", Icons.arrow_back, () {

                  }),
                  Row(
                    children: <Widget>[
                      renderButton(Image.asset( index == 1 ?"assets/images/forward.png" : "assets/images/send-to-friends-inactive.png", width: 50,), isActive: index == 1, text: "Send to Friends", onTap: () => setState(() => index = 1) ),
                      renderButton(Image.asset( index == 1 ?"assets/images/surface.png" : "assets/images/surface-active.png", width: 60, height: 40,), isActive:  index == 2, text: "Bank", onTap: () => setState(() => index = 2) ),
                    ],
                  ),
                  index == 1 ?  renderSendToFriends() : renderSendWithBank()
                  ]),
              )
        )
    )
    );
  }
}

