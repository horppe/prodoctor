import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<FirebaseUser> signWithEmailandPassword({String email, String password}) async {
    try {
     AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // Create User with email and password
  Future<FirebaseUser> createUserWithEmailandPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}