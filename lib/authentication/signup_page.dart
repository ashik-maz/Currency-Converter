import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebaseauthservice.dart';
import 'formcontainer.dart';
import 'toast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isSigningUp = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuthService _auth = FirebaseAuthService();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signupWithEmailAndPassword(email, password);

      if (user != null) {
        try {
          await users.doc(user.uid).set({
            'name': username,
            'email': email,
            'cid': user.uid,
            'profileImage': '', // Can leave empty or remove this line entirely
          });

          showToast(message: "User Successfully Created");
          Navigator.pushNamed(context, "/home");
        } catch (e) {
          showToast(message: "Firestore write error: $e");
        }
      } else {
        showToast(message: "Error during sign up!");
      }
    } catch (e) {
      showToast(message: "Sign up error: $e");
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      FormContainerWidget(
                        controller: _usernameController,
                        hintText: "Username",
                        ispasswordfield: false,
                        validator: (value) =>
                            value?.isEmpty ?? true ? "Enter username" : null,
                      ),
                      const SizedBox(height: 10),
                      FormContainerWidget(
                        controller: _emailController,
                        hintText: "Email",
                        ispasswordfield: false,
                        validator: (value) =>
                            value?.isEmpty ?? true ? "Enter email" : null,
                      ),
                      const SizedBox(height: 10),
                      FormContainerWidget(
                        controller: _passwordController,
                        hintText: "Password",
                        ispasswordfield: true,
                        validator: (value) => value != null && value.length < 6
                            ? "Password must be at least 6 characters"
                            : null,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: _isSigningUp
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
