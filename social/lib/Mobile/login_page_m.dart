import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/Theme/theme_notifier.dart';
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
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final currentLanguage = themeNotifier.currentLanguage;
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
            title: Text(currentLanguage["error"] ?? "Error"),
            content: Text(
                currentLanguage["email or password cannot be empty"] ??
                    "Email or password cannot be empty"),
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
      showMessage(
          context,
          currentLanguage["error"] ?? "Error",
          currentLanguage["invalid email or password"] ??
              "Invalid email or password");
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                SizedBox(height: 30),
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
                MyElevatedButton(
                    text: currentLanguage["login"] ?? "Login",
                    onPressed: () {
                      _login();
                    }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentLanguage["don't have an account?"] ??
                        "Don't have an account?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        currentLanguage["let's register!"] ??
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
