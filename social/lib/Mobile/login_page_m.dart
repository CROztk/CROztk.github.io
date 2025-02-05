import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_appbar.dart';
import 'package:social/components/my_elevated_button.dart';
import 'package:social/components/my_textfield.dart';
import 'package:social/helper_functions.dart';

class MyLoginPageMobile extends StatefulWidget {
  final void Function()? onTap;
  const MyLoginPageMobile({super.key, required this.onTap});

  @override
  State<MyLoginPageMobile> createState() => _MyLoginPageMobileState();
}

class _MyLoginPageMobileState extends State<MyLoginPageMobile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login method
  void _login() async {
    final String username = _emailController.text;
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
    // check email and password
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Email or password cannot be empty"),
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

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // close dialog
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // close dialog
      Navigator.of(context).pop();
      // show error dialog
      showMessage(context, "Error", "Invalid email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: "s o C I a l"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 30),
                MyTextfield(
                    text: "Email",
                    obscureText: false,
                    controller: _emailController),
                SizedBox(height: 10),
                MyTextfield(
                    text: "Password",
                    obscureText: true,
                    controller: _passwordController),
                SizedBox(height: 10),
                MyElevatedButton(
                    text: "Login",
                    onPressed: () {
                      _login();
                    }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Let's register!",
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
