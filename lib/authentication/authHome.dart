
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'toast.dart';

class AuthHome extends StatefulWidget {
  const AuthHome({Key? key,});

  @override
  State<AuthHome> createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  bool _isSigningOut=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(child: Column(
              children: [
                Text("Welcome Home Buddy🥰",style: TextStyle(fontSize: 30),),
            
            
            
                SizedBox(height: 30,),
            GestureDetector(
                  onTap: (){
                    
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                    showToast(message: "User is Successfully Signed Out");
                  },
                  child: Container(
                    width: 120,
                    height: 45,
                    
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                    child: Center(child: _isSigningOut?CircularProgressIndicator(color: Colors.white,) :Text("Logout",style: TextStyle(color: Colors.white,fontSize: 18, fontWeight: FontWeight.bold),)),
                  ),
                 
                )
              ],
            )),
          ),
          
        ],
      ),
    ),
    );
  }
}