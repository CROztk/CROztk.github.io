import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_elevated_button.dart';
import 'package:social/components/my_textfield.dart';

class MyRegisterPageDesktop extends StatefulWidget {
  final void Function()? onTap;
  const MyRegisterPageDesktop({super.key, required this.onTap});

  @override
  State<MyRegisterPageDesktop> createState() => _MyRegisterPageDesktopState();
}

class _MyRegisterPageDesktopState extends State<MyRegisterPageDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // register method
  void _register() async {
    // loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // check password
    if (_passwordController.text != _passwordCheckController.text) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Passwords do not match"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // check email
    List<String> emailParts = _emailController.text.split("@");
    if (emailParts.length != 2 ||
        emailParts[0].isEmpty ||
        emailParts[1].split(".").length != 2 ||
        emailParts[1].split(".")[0].isEmpty ||
        emailParts[1].split(".")[1].isEmpty) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Invalid email"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    // check if username unique
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: _usernameController.text)
        .get();
    if (query.docs.isNotEmpty) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Username already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // try to create account
    try {
      // create account
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      // create user document and save to the database
      createUserDocument(userCredential);

      // close dialog
      Navigator.pop(context);
    } catch (e) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          String text = e.toString().split("]")[1].trim();
          return AlertDialog(
            title: const Text("Error"),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void createUserDocument(UserCredential? userCredential) {
    if (userCredential != null && userCredential.user != null) {
      // create user document
      Map<String, dynamic> user = {
        "email": userCredential.user!.email,
        "username": _usernameController.text,
        "followers": [],
        "following": [],
        "bio": "",
        "dob": "",
      };

      // save user document to the database
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.email)
          .set(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.all(50.0), // Increased padding for desktop
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600), // Limit the width
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 120, // Increased icon size for desktop
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(height: 40), // Increased spacing
                    MyTextfield(
                        text: "Username",
                        obscureText: false,
                        controller: _usernameController),
                    SizedBox(height: 20),
                    MyTextfield(
                        text: "Email",
                        obscureText: false,
                        controller: _emailController),
                    SizedBox(height: 20),
                    MyTextfield(
                        text: "Password",
                        obscureText: true,
                        controller: _passwordController),
                    SizedBox(height: 20),
                    MyTextfield(
                        text: "Confirm Password",
                        obscureText: true,
                        controller: _passwordCheckController),
                    SizedBox(height: 30), // Increased spacing
                    MyElevatedButton(
                        text: "Create Account",
                        onPressed: () {
                          _register();
                        }),
                    SizedBox(height: 30), // Increased spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            " Let's login!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
