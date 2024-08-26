
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebaseauthservice.dart';
import 'formcontainer.dart';
import 'toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool _isSigning=false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _emailcontroller,
                hintText: "Email",
                ispasswordfield: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordcontroller,
                hintText: "Password",
                ispasswordfield: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _signin,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue),
                  child: Center(
                      child: _isSigning ? CircularProgressIndicator(color: Colors.white,) : Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(height: 16,),



              GestureDetector(
                onTap:(){
                  //  _signInWithGoogle();
                } ,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.google, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("Sign in with Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                                            ),
                        ],
                      )),
                ),
              ),


              
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  void _signin() async {

    setState(() {
      _isSigning =true;
    });

    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;

    User? user = await _auth.signinWithEmailAndPassword(email, password);


    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is Successfully sign in");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some Error happened!");
    }
  }



  // _signInWithGoogle() async {


  //   final GoogleSignIn _googleSignIn = GoogleSignIn();


  //   try {
      
  //     final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //      if(googleSignInAccount != null){

  //       final GoogleSignInAuthentication  googleSignInAuthentication = await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(

  //         idToken: googleSignInAuthentication.idToken,
  //         accessToken:  googleSignInAuthentication.accessToken
  //       );

  //       await _firebaseAuth.signInWithCredential(credential);
  //       Navigator.pushNamed(context, "/home");

  //      }


  //   } catch (e) {
  //     showToast(message: "Some Error occured $e");
      
  //   }
  // }
  
}