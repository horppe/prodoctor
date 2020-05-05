import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:practiceapp/blocs/cart_bloc.dart';
import 'package:practiceapp/models/cart_item.dart';
import 'package:practiceapp/models/product.dart';
import 'package:practiceapp/utils/colors.dart';
import 'package:practiceapp/widgets/app_text.dart';
import 'package:practiceapp/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  // final Lesson lesson;
  ProductDetail({Key key}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  CartBloc _cartBloc;
  ScrollController cartListController = new ScrollController();

  addToCart(Product product) {
    AddItemEvent event = AddItemEvent(
        item: CartItem(
            productId: product.id,
            name: product.name,
            id: product.id + product.name));
    _cartBloc.cartEventSink.add((event));
  }

  @override
  void initState() {
    super.initState();
    _cartBloc = Provider.of<CartBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Box<Product> box = Hive.box<Product>('selectedProduct');
    Product product = box.get("product",
        defaultValue: Product(
          userId: "skhdfahkjdnjkfands",
          name: "No Product",
          price: 0.0,
          quantity: 0,
        ));

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 120.0),
        Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.7), borderRadius: BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                BottomCartSheet.showSheet(
                    context: context, cartListController: cartListController);
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 40.0,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        AppText(
          product.name,
          textStyle: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 20.0,
          top: 50.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(AntDesign.arrowleft, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = AppText(
      "\$ ${product.price}",
      textStyle: TextStyle(fontSize: 18.0),
    );
    final bottomContent = (bool added) => Container(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              children: <Widget>[
                bottomContentText,
                Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: added
                          ? null
                          : () {
                              addToCart(product);
                            },
                      color: Color.fromRGBO(58, 66, 86, 1.0),
                      child: AppBoldText(added ? "Added" : "Add to cart",
                          textStyle: TextStyle(color: Colors.white)),
                    ))
              ],
            ),
          ),
        );

    return Scaffold(
        body: StreamBuilder<IncomingState>(
      stream: _cartBloc.state, // a Stream<int> or null
      initialData: CartState(items: []),
      builder: (BuildContext context, AsyncSnapshot<IncomingState> snapshot) {
        var renderBottom = ({bool added}) {
          return Column(
            children: <Widget>[topContent, bottomContent(added)],
          );
        };
        if (snapshot.hasError)
          return AppText(
            'Error: ${snapshot.error}',
          );
        bool addedToCart = false;
        (snapshot.data as CartState).items.forEach((item) {
          if (item.productId == product.id) {
            addedToCart = true;
          }
        });

        return renderBottom(added: addedToCart); // unreachable
      },
    ));
  }
}
