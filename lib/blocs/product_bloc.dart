 
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practiceapp/blocs/bloc_types.dart';
import 'package:practiceapp/models/product.dart';
import 'package:practiceapp/screens/home/home.dart';
import 'package:practiceapp/screens/product_detail/product_detail.dart';
import 'package:practiceapp/services/product.dart';
import 'package:rxdart/subjects.dart';

class ProductState extends IncomingState {
  final List<Product> products;
  ProductState({@required this.products});
}

class NoProductState extends ProductState {
  NoProductState() : super(products: []);
}

class AlreadyExistState extends ProductState {
  AlreadyExistState({List<Product> prods = const []})  : super(products: prods);
}


class AddProductEvent extends IncomingEvent {
  final Product product;
  final CreateProductCallback callback;
  AddProductEvent({@required this.product, @required this.callback});
}

class RemoveProductEvent extends IncomingEvent {
  final String productId;
  final RemoveProductCallback callback;
  RemoveProductEvent({@required this.productId, @required this.callback});
}

class ProductBloc {
  IncomingState _state = ProductState(products: List.unmodifiable([]));
  final ProductService _productService = ProductService();
  final Firestore _db = Firestore.instance;
  FirebaseUser _user;

  final StreamController<IncomingEvent> _eventStreamController =
      BehaviorSubject<IncomingEvent>();
  final StreamController<IncomingState> _stateStreamController =
      BehaviorSubject<IncomingState>(); 

  StreamSink<IncomingState> get _inState => _stateStreamController.sink;
  Stream<IncomingState> get state =>
      _stateStreamController.stream.asBroadcastStream();

  StreamSink<IncomingEvent> get productEventSink => _eventStreamController.sink;

  ProductBloc() {
    print("Product Bloc Initialized");
    register();
    // Listen for UI event with _mapEventToState
    _eventStreamController.stream.listen(_mapEventToState);
    
  }

  register() {
    FirebaseAuth.instance.currentUser().then((usr){
      _user = usr;
      updateProducts();
      });
  }

  void _mapEventToState(IncomingEvent event) {
    print("mapEventToState");
    switch (event.runtimeType) {
      case AddProductEvent:
        mapAddItemtoState(event);
        break;
      case RemoveProductEvent:
        mapRemoveProductToState(event);
        break;
      default:
        break;
    }
  }

  mapAddItemtoState(AddProductEvent event) {
    print('mapAddItemtoState');

    Product product = event.product;

    _productService.findByName(product.name).then((prod) {
      if (prod != null) {
        event.callback.onCreateError("Product already exists");
      } else {
        // Add Item to _db
        _productService.save(product).then((ref) {
          event.callback.onCreateSucess(product);
          updateProducts();
        });
      }
    });
   
  }

  updateProducts(){
    print("Update Products");
    if(_user != null){
      List<Product> products = List();
      _db
      .collection(ProductService.collectionName)
      .where("userId", isEqualTo: _user.uid).getDocuments()
      .then((value){
        if(value.documents.length < 1){
          _state = NoProductState();
        } else {
          value.documents.forEach((doc) {
            products.add(Product.fromSnapshot(doc));
          });

          _state = ProductState(products: products);
        }
        _inState.add(_state);
      });
    }
      
  }

  mapRemoveProductToState(RemoveProductEvent event) {
     print("mapRemoveProductToState");

      _productService.remove(id: event.productId).then(
        (_){
          event.callback.onDeleteSuccess();
          updateProducts();
        }
      );

  }

  dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
