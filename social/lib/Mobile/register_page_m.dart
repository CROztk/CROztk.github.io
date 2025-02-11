import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_elevated_button.dart';
import 'package:social/components/my_textfield.dart';

class MyRegisterPageMobile extends StatefulWidget {
  final void Function()? onTap;
  const MyRegisterPageMobile({super.key, required this.onTap});

  @override
  State<MyRegisterPageMobile> createState() => _MyRegisterPageMobileState();
}

class _MyRegisterPageMobileState extends State<MyRegisterPageMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // login method
  void _register() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
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
            title: Text(currentLanguage["error"] ?? "Error"),
            content: Text(currentLanguage["passwords do not match"] ??
                "Passwords do not match"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(currentLanguage["ok"] ?? "OK"),
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
            title: Text(currentLanguage["error"] ?? "Error"),
            content: Text(currentLanguage["invalid email"] ?? "Invalid email"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(currentLanguage["ok"] ?? "OK"),
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
            title: Text(currentLanguage["error"] ?? "Error"),
            content: Text(currentLanguage["username already exists"] ??
                "Username already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(currentLanguage["ok"] ?? "OK"),
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
            title: Text(currentLanguage["error"] ?? "Error"),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(currentLanguage["ok"] ?? "OK"),
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
        "dob": Timestamp.now(),
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
    return Scaffold(
      appBar: MyAppbar(title: currentLanguage["title"] ?? "s o C I a l"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 30),
                MyTextfield(
                    text: currentLanguage["username"] ?? "Username",
                    obscureText: false,
                    controller: _usernameController),
                SizedBox(height: 10),
                MyTextfield(
                    text: currentLanguage["email"] ?? "Email",
                    obscureText: false,
                    controller: _emailController),
                SizedBox(height: 10),
                MyTextfield(
                    text: currentLanguage["password"] ?? "Password",
                    obscureText: true,
                    controller: _passwordController),
                SizedBox(height: 10),
                MyTextfield(
                    text: currentLanguage["confirm password"] ??
                        "Confirm Password",
                    obscureText: true,
                    controller: _passwordCheckController),
                SizedBox(height: 10),
                MyElevatedButton(
                    text: currentLanguage["create account"] ?? "Create Account",
                    onPressed: () {
                      _register();
                    }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentLanguage["already have an account?"] ??
                        "Already have an account?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        currentLanguage["let's login!"] ?? " Let's login!",
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
    );
  }
}
