import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';

class MyUsersPageTablet extends StatelessWidget {
  const MyUsersPageTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for dynamic font size adjustment
    double screenWidth = MediaQuery.of(context).size.width;
    double usernameFontSize = screenWidth < 600 ? 22 : 24; // Larger for tablet
    double emailFontSize =
        screenWidth < 600 ? 18 : 20; // Slightly larger than mobile

    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  const Icon(Icons.people_alt, size: 100),
                  Text("Something went wrong"),
                ],
              ),
            );
          }

          // success state
          if (snapshot.hasData) {
            // Extract data
            final users = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns for tablet layout
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 3, // Adjusted for better spacing
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      users[index]["username"],
                      style: TextStyle(
                          fontSize: usernameFontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      users[index]["email"],
                      style: TextStyle(fontSize: emailFontSize),
                    ),
                    leading: const Icon(Icons.person, size: 60),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                );
              },
            );
          }

          // no data state
          return Center(
            child: Column(
              children: [
                const Icon(Icons.person, size: 100),
                Text("No users found", style: const TextStyle(fontSize: 22)),
              ],
            ),
          );
        },
      ),
    );
  }
}
