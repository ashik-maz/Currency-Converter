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
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildScaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return _buildScaffold(
            body: Center(child: Text("Something went wrong: ${snapshot.error}")),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildScaffold(
            body: const Center(child: Text("Document does not exist")),
          );
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

        return _buildScaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "EMAIL: ${data['email']?.toUpperCase() ?? 'No email'}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "NAME: ${data['name']?.toUpperCase() ?? 'No name'}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
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
                    child: const Text(
                      "Log out",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Scaffold _buildScaffold({required Widget body}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: body,
    );
  }
}
