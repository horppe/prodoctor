import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practiceapp/blocs/cart_bloc.dart';
import 'package:practiceapp/models/cart_item.dart';
import 'package:practiceapp/models/product.dart';
import 'package:practiceapp/services/product.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/widgets/app_text.dart';
import 'package:practiceapp/utils/dimensions.dart';
import 'package:practiceapp/widgets/bottom_sheet.dart';
import 'package:practiceapp/widgets/text_input_one.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int index = 1;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final ProductService productService = ProductService();
  ScrollController scrollController = new ScrollController();
  ScrollController cartListController = new ScrollController();

  bool creatingProduct = false;
  Stream<QuerySnapshot> productStream;

  initState() {
    super.initState();
    productService.getAllStream().then((value) {
      productStream = value;
    });
    Hive.initFlutter();
    Hive.registerAdapter(ProductAdapter());
  }

  createProduct() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        creatingProduct = true;
      });
      String name = nameController.text;
      String price = priceController.text;
      String quantity = quantityController.text;
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      Product newProduct = Product(
          name: name,
          price: double.parse(price),
          quantity: double.parse(quantity),
          userId: user.uid);
      final ProductService productService = ProductService();
      try {
        DocumentReference result = await productService.save(newProduct);
        if (result != null) {
          setState(() {
            creatingProduct = false;
            index = 1;
          });
          showToast("Product $name was added sucessfully");
          nameController.clear();
          priceController.clear();
          quantityController.clear();
        }
      } catch (e) {
        setState(() {
          creatingProduct = false;
        });
        print(e.toString());
      }
    } else {
      // print("Invalid Form");
    }
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

  Widget renderButton(Widget image,
      {bool isActive = false, String text = "", Function onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color(CustomColorData.inactiveBackground),
                        width: 1 * .6),
                    color: Color(isActive
                        ? CustomColorData.inactiveBackground
                        : CustomColorData.white),
                    borderRadius: BorderRadius.circular(10)),
                constraints: BoxConstraints(
                    minHeight: 100,
                    minWidth: Dimensions.getWidth("40", context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    image,
                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    AppBoldText(text,
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(isActive
                                ? CustomColorData.white
                                : CustomColorData.inactiveBackground),
                            letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget renderCreateProduct() {
    return Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
            TextInputOne(
              //     keyboardType: TextInputType.numberWithOptions(decimal: true),
              label: "Product Name",
              controller: nameController,
              validator: (str) {
                if (str.toString().isEmpty) {
                  return "";
                }

                if (str.toString().length < 2) {
                  return "Name too short";
                }

                return null;
              },
            ),
            TextInputOne(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              label: "Price",
              controller: priceController,
              validator: (str) {
                if (str.toString().isEmpty) {
                  return "";
                }

                return null;
              },
            ),
            TextInputOne(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              label: "Quantity",
              controller: quantityController,
              validator: (str) {
                if (str.toString().isEmpty) {
                  return "";
                }

                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.getWidth("5", context),
                  vertical: Dimensions.getHeight("2", context)),
              child: GestureDetector(
                onTap: () {
                  createProduct();
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Color(CustomColorData.inactiveBackground),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                      child: creatingProduct
                          ? CircularProgressIndicator(
                              strokeWidth: 4,
                              backgroundColor: Colors.white,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(CustomColorData.primary)))
                          : AppBoldText("Save",
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 15))),
                ),
              ),
            )
          ],
        ));
  }

  Widget renderProduct({Product product}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 14),
      child: GestureDetector(
        onTap: () {
          Hive.isBoxOpen("selectedProduct")
              ? Hive.box<Product>('selectedProduct')
                  .put("product", product)
                  .then((value) =>
                      Navigator.of(context).pushNamed("ProductDetail"))
              : Hive.openBox<Product>('selectedProduct').then((Box box) {
                  box.put("product", product);
                  Navigator.of(context).pushNamed("ProductDetail");
                });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Color(CustomColorData.borderInactive))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(
                      product.name,
                      textStyle: TextStyle(
                          letterSpacing: .5,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget renderProducts() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.getWidth("2", context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Dimensions.getHeight("2", context)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.getWidth("3", context),
                vertical: Dimensions.getHeight("0.5", context)),
            child: AppText(
              "Products",
              textStyle:
                  TextStyle(fontWeight: FontWeight.w700, letterSpacing: .5),
            ),
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Dimensions.getHeight("60", context)),
            child: StreamBuilder<QuerySnapshot>(
              stream: productStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: AppText(
                      'No Products to display',
                      textStyle: TextStyle(fontSize: 14),
                    ),
                  );
                }
                if (snapshot.hasError)
                  return new AppText('Error: ${snapshot.error}',
                      textStyle: TextStyle(fontSize: 14));
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new AppText(
                      'Loading...',
                      textStyle: TextStyle(fontSize: 14),
                    );
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return renderProduct(
                            product: Product.fromSnapshot(document));
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: AppBoldText(
            "Home",
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.end,
          ),
          actions: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(right: Dimensions.getWidth("6", context)),
              child: GestureDetector(
                  onTap: () {
                    BottomCartSheet.showSheet(context: context, cartListController: cartListController);
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
            )
          ],
        ),
        body: DirectSelectContainer(
            child: SafeArea(
                //  bottom: false,
                child: new SingleChildScrollView(
          controller: scrollController,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Header("Home", Icons.arrow_back, () {}),
                Row(
                  children: <Widget>[
                    // renderButton(Image.asset( index == 1 ?"assets/images/forward.png" : "assets/images/send-to-friends-inactive.png", width: 50,), isActive: index == 1, text: "Products", onTap: () => setState(() => index = 1) ),
                    renderButton(
                        Icon(Icons.view_list,
                            size: 40,
                            color: index == 1
                                ? Colors.white
                                : Color(CustomColorData.inactiveBackground)),
                        isActive: index == 1,
                        text: "Products",
                        onTap: () => setState(() => index = 1)),

                    renderButton(
                        Icon(Icons.create,
                            size: 40,
                            color: index == 2
                                ? Colors.white
                                : Color(CustomColorData.inactiveBackground)),
                        isActive: index == 2,
                        text: "Create Product",
                        onTap: () => setState(() => index = 2)),
                  ],
                ),
                index == 1 ? renderProducts() : renderCreateProduct()
              ]),
        ))));
  }
}
