
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'toast.dart';

class FirebaseAuthService{
  FirebaseAuth _auth= FirebaseAuth.instance;
  Future <User?> signupWithEmailAndPassword(String email,String password) async{

    try {
      UserCredential credential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use'){
        showToast(message: "The Email address is already in use.");
      }
      else{
      showToast(message: "Some error Occured: ${e.code}");

      }
    }
    return null;

  }

  Future <User?> signinWithEmailAndPassword(String email,String password) async{

    try {
      UserCredential credential= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if(e.code=='user-not-found'  || e.code=='wrong-password'){
        showToast(message: "Invalid Email or Password");
      }
      else{
      showToast(message: "Some error Occured: ${e.code}");

      }
    }
    return null;

  }

}