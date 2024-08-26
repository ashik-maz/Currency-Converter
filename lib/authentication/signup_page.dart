import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await _picker.pickImage(
        source: source,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      showToast(message: "Image picking error: $e");
    }
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
    // Sign up the user with email and password
    User? user = await _auth.signupWithEmailAndPassword(email, password);

    if (user != null) {
      String? profileImage;
      
      // Upload profile image if selected
      if (_imageFile != null) {
        try {
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
              .ref('images/${user.uid}.jpg');

          await ref.putFile(File(_imageFile!.path));
          profileImage = await ref.getDownloadURL();
        } catch (e) {
          showToast(message: "Image upload error: $e");
          print("Image upload error: $e");
        }
      }

      // Save user data in Firestore
      try {
        await users.doc(user.uid).set({
          'name': username,
          'email': email,
          'cid': user.uid,
          'profileImage': profileImage ?? '',
        });
        
        showToast(message: "User Successfully Created");
        Navigator.pushNamed(context, "/home");
      } catch (e) {
        showToast(message: "Firestore write error: $e");
        print("Firestore write error: $e");
      }
    } else {
      showToast(message: "Error during sign up!");
    }
  } catch (e) {
    showToast(message: "Sign up error: $e");
    print("Sign up error: $e");
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                              child: _imageFile == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _pickImage(ImageSource.camera),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
