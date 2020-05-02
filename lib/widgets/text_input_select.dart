import 'package:flutter/material.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:direct_select_flutter/generated/i18n.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:practiceapp/widgets/app_text.dart';

class TextInputSelect extends StatelessWidget{

  final amountController = TextEditingController();
  String label;
  TextInputSelect({this.label, this.values });
  List<String> values;
  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 50,
        value: value,
        itemBuilder: (context, value) {
          return AppText(value, textStyle: TextStyle(fontSize: 14),);
        });
  }
  _getDslDecoration() {
    return BoxDecoration(

      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppText(label, textStyle: TextStyle(fontSize: 14),),
            Padding(padding: EdgeInsets.symmetric(vertical: 3),),
            Container(
              constraints: BoxConstraints.expand(height: 50),
              decoration: BoxDecoration(
                border: Border.all(color: Color(CustomColorData.borderInactive), width: 1,),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth("4", context)),
                child: DirectSelectList<String>(
                    values: values,
                    defaultItemIndex: 0,

                    itemBuilder: (String value) => getDropDownMenuItem(value),
                    focusedItemDecoration: _getDslDecoration(),
                    onItemSelectedListener: (item, index, context) {
//                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(item)));
                    }),
              ),

            )

          ],
        )
    );


  }
}