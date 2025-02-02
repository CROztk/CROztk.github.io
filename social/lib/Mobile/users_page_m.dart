import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyUsersPageMobile extends StatelessWidget {
  const MyUsersPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppbar(title: "s o C I a l"),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Icon(Icons.people_alt, size: 80),
                    Text("Something went wrong"),
                  ],
                ),
              );
            }
            // success
            if (snapshot.hasData) {
              // extract data
              final users = snapshot.data!.docs;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index]["username"]),
                    subtitle: Text(users[index]["email"]),
                  );
                },
              );
            }
            // no data
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.person, size: 80),
                  Text("No users found"),
                ],
              ),
            );
          },
        ));
  }
}
