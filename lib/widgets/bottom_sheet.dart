import 'package:flutter/material.dart';
import 'package:practiceapp/blocs/bloc_types.dart';
import 'package:practiceapp/blocs/cart_bloc.dart';
import 'package:practiceapp/models/cart_item.dart';
import 'package:practiceapp/widgets/app_text.dart';
import 'package:provider/provider.dart';
class BottomCartSheet {
  static Widget _renderCartItem({CartItem item, BuildContext context}){
    CartBloc _cartBloc = Provider.of<CartBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black54, width: .7,), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            AppBoldText("Name: "+item.name, textStyle: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: (){
                print("Heu");
                _cartBloc.cartEventSink.add(RemoveItemEvent(itemId: item.id));
              },
              child: Icon(Icons.remove_circle, color: Colors.red,)
            )
          ],)
        )
        ),
    );
  } 

  static showSheet({BuildContext context, ScrollController  cartListController}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          CartBloc _cartBloc = Provider.of<CartBloc>(context, listen: false);
          return Container(
              //  constraints: BoxConstraints(minHeight: 300),
              child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AppBoldText(
                      "Cart",
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 5,),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    child: StreamBuilder<IncomingState>(
                        stream: _cartBloc.state, // a Stream<int> or null
                        initialData: CartState(items: []),

                        builder: (BuildContext context,
                            AsyncSnapshot<IncomingState> snapshot) {
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              
                              var myState = snapshot.data;
                             
                              
                              if(myState is CartState){
                                if(myState.items.length < 1){
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      AppText("No item inside Cart", textStyle: TextStyle(fontSize: 16),),
                                    ],
                                  );
                                }
                                  return ListView(
                                  controller: cartListController,
                                  children: myState.items
                                      .map((item) => _renderCartItem(item: item, context: context))
                                      .toList(),
                                );
                              }



                          
                        })),
              ),
            ],
          ));
        });
  }
}
  