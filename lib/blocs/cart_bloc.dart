 
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practiceapp/blocs/bloc_types.dart';
import 'package:practiceapp/models/cart_item.dart';
import 'package:rxdart/subjects.dart';

class AddItemEvent extends IncomingEvent {
  final CartItem item;
  AddItemEvent({@required this.item});
}


class CartState extends IncomingState {
  final List<CartItem> items;
  CartState({@required this.items});
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
