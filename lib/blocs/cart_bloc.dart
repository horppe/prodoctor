//Customised state @immutable
import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
import 'package:practiceapp/models/cart_item.dart';
import 'package:rxdart/subjects.dart';

@immutable
abstract class IncomingState {}

class InitialIncomingState extends IncomingState {}

class CartState extends IncomingState {
  final List<CartItem> items;
  CartState({@required this.items});
}

@immutable
abstract class IncomingEvent {}

class AddItemEvent extends IncomingEvent {
  final CartItem item;
  AddItemEvent({@required this.item});
}

class RemoveItemEvent extends IncomingEvent {
  final String itemId;
  RemoveItemEvent({@required this.itemId});
}

class CartBloc {
  IncomingState _state = CartState(items: List.unmodifiable([]));

  final StreamController<IncomingEvent> _eventStreamController = BehaviorSubject<IncomingEvent>();
  final StreamController<IncomingState> _stateStreamController = BehaviorSubject<IncomingState>(); // StreamController<IncomingState>();

  StreamSink<IncomingState> get _inState => _stateStreamController.sink;
  Stream<IncomingState> get state => _stateStreamController.stream.asBroadcastStream();


  StreamSink<IncomingEvent> get cartEventSink => _eventStreamController.sink;

  CartBloc(){
    // Listen for UI event with _mapEventToState
    _eventStreamController.stream.listen(_mapEventToState);
  }
  
  void _mapEventToState(IncomingEvent event) {
    // print("mapEventToState");
    switch (event.runtimeType) { 
      case AddItemEvent : mapAddItemtoState(event);
        break;
      case RemoveItemEvent : mapRemoveItemToState(event);
        break;
      default: 
        break;
    }

  }

  mapAddItemtoState(AddItemEvent event)  {
    // print('mapAddItemtoState');
    List<CartItem> items = (_state as CartState).items;
    bool isFound = false;

    items.forEach((item) {
      if(item.id == event.item.id){
        isFound = true;
      }
    });

    if(isFound){
      return;
    }
    _state = CartState(items: List.from(items)..add(event.item));
    _inState.add(_state);
  }

 mapRemoveItemToState(RemoveItemEvent event) {
  //  print("mapRemoveItemToState");
    _state = CartState(items: List.from((_state as CartState).items)..removeWhere((item) {
      return  item.id == event.itemId;
    }));
    _inState.add(_state);
  }

  dispose(){
    _stateStreamController.close();
    _eventStreamController.close();
  }

 }




// class CartBloc extends Bloc<IncomingEvent, IncomingState> {

//   final StreamController<IncomingEvent> _eventStreamController = StreamController<IncomingEvent>();
//   final StreamController<IncomingState> _stateStreamController;

//   Sink get updateUser => _eventStreamController.sink;
//   Stream<User> get user => _eventStreamController.stream;

//   CartBloc(){

//   }


//   @override
//   IncomingState get initialState => CartState(items: List.unmodifiable([]));

//   @override
//   Stream<IncomingState> mapEventToState(IncomingEvent event) async* {
//     print("mapEventToState");
//     switch (event.runtimeType) { 
//       case AddItemEvent : yield* mapAddItemtoState(event);
//         break;
//       case RemoveItemEvent : yield* mapRemoveItemToState(event);
//         break;
//       default:
//     }
//     yield null;
//   }

//   Stream<IncomingState> mapAddItemtoState(AddItemEvent event) async* {
//     print("mapAddItemtoState");
//     print(event);
//     yield CartState(items: List.from((state as CartState).items)..add(event.item));
//   }

//   Stream<IncomingState> mapRemoveItemToState(RemoveItemEvent event) async* {
//     print("mapRemoveItemToState");
//     print(event);
//     yield CartState(items: List.from((state as CartState).items)..removeWhere((item) {
//       return  item.productId != event.itemId;
//     }));
//   }

//  }
