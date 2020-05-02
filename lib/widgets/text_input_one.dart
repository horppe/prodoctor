import 'package:flutter/material.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:practiceapp/widgets/app_text.dart';

class TextInputOne extends StatelessWidget{

  TextEditingController controller;
  String label;
  TextInputType keyboardType = TextInputType.text;
  bool obsureText;
  FormFieldValidator validator;
  TextInputOne({this.label, this.keyboardType, this.obsureText = false, this.validator, this.controller});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(label, textStyle: TextStyle(fontSize: 14),),
                   SizedBox(height: 5,),
                    Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: TextFormField(
                        obscureText: obsureText,
                        keyboardType: keyboardType,
                        controller: controller,
                        validator: validator,
                        textAlignVertical: TextAlignVertical.center,
                       style: TextStyle( fontFamily: "Poppins" ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(CustomColorData.primary), width: .8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(CustomColorData.borderInactive), width: .8),
                          ),
                          // errorBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.red.shade600, width: .8),gapPadding: 100
                          // ),
                          errorStyle: TextStyle(height: 50,),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)

                        ),
                      ),
                    )

                  ],
                )
            );
  }
}