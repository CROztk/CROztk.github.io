import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_elevated_button.dart';
import 'package:social/components/my_textfield.dart';

class MyLoginPageMobile extends StatefulWidget {
  const MyLoginPageMobile({super.key});

  @override
  State<MyLoginPageMobile> createState() => _MyLoginPageMobileState();
}

class _MyLoginPageMobileState extends State<MyLoginPageMobile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login method
  void _login() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // show dialog circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // close dialog
      Navigator.of(context).pop();
    } catch (e) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: Center(
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
                  text: "Username",
                  obscureText: false,
                  controller: _usernameController),
              SizedBox(height: 10),
              MyTextfield(
                  text: "Password",
                  obscureText: true,
                  controller: _passwordController),
              SizedBox(height: 10),
              MyElevatedButton(text: "Login", onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }
}
