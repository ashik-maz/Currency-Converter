import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/alert_dialog.dart';

class Profile extends StatefulWidget {
  final String documentId;
  const Profile({super.key, required this.documentId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while fetching data
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          // Handle errors
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Center(
              child: Text("Something went wrong: ${snapshot.error}"),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          // Handle document not found
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Profile'),
              backgroundColor: Colors.blue,
              centerTitle: true,
            ),
            body: Center(
              child: Text("Document does not exist"),
            ),
          );
        }

        // Document exists, display data
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Profile'),
            backgroundColor: Colors.blue,
            centerTitle: true,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(data['profileImage'] ??
                      'https://en.wikipedia.org/wiki/File:Myosotis_arvensis_ois.JPG'),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text(
                      "EMAIL: ",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      data['email']?.toUpperCase() ?? 'No email',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Text("NAME: ",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(
                      data['name']?.toUpperCase() ?? 'No name',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    MyAlertDilaog.showMyDialog(
                      context: context,
                      title: 'Log Out',
                      content: 'Are you sure you want to log out?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    );
                  },
                  child: Text(
                    "Log out",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
