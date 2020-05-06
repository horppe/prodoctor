import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practiceapp/models/product.dart';



class ProductService {
  static final String collectionName = "products";
  final Firestore db = Firestore.instance;
    
  Future<DocumentReference> save(Product product) async {

    try {
      var result = db.collection(ProductService.collectionName).add({
        "name" : product.name,
        "price" : product.price,
        "quantity" : product.quantity,
        "userId": product.userId
      });
      return result;
    } catch(e){
      print(e.toString());
      return null;
    }
    

  }

  Future remove({String id}){
    return db.collection(ProductService.collectionName).document(id).delete();
  }


  Future<Stream<QuerySnapshot>> getAllStream() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    try {
      var resultStream = db
      .collection(ProductService.collectionName)
      .where("userId", isEqualTo: user.uid)
      .snapshots();
      return resultStream;
    } catch(e){
      return null;
    }
  }


  
  Future<DocumentSnapshot> findByName(String name) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    try {
      var result = await db.collection(ProductService.collectionName)
      .where("userId", isEqualTo: user.uid)
      .where("name", isEqualTo: name)
      .getDocuments();

      return result.documents.first;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future<DocumentSnapshot> findById(String id) async{
    
    try {
      var result = await db.collection(ProductService.collectionName).document(id).get();
      return result;
    } catch (e){
      print(e.toString());
      return null;
    }
  }
}