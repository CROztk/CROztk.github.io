import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyProfilePageTablet extends StatelessWidget {
  MyProfilePageTablet({super.key});

  // current user
  final currentUser = FirebaseAuth.instance.currentUser;

  // get details of the user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar(title: "s o C I a L"),
        body: FutureBuilder(
          future: getUserDetails(),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // error
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.face_retouching_off, size: 120),
                  Text("Something went wrong", style: TextStyle(fontSize: 24)),
                ],
              );
            }
            // success
            if (snapshot.hasData) {
              // extract data
              Map<String, dynamic>? user = snapshot.data!.data();

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.face, size: 120),
                    Text(
                      user!["username"],
                      style:
                          TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                    ),
                    Text(user["email"], style: TextStyle(fontSize: 24)),
                  ],
                ),
              );
            }

            // no data
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.face_retouching_off, size: 120),
                Text("No data", style: TextStyle(fontSize: 24)),
              ],
            );
          },
        ));
  }
}
