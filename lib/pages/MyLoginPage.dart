// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Uri _recoveryUrl =
        Uri.parse('https://accounts.google.com/signin/v2/usernamerecovery');
    final Uri _signUpUrl = Uri.parse('https://accounts.google.com/signup');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
          child: Container(
        width: width > 600 ? 550 : width,
        height: width > 600 ? 500 : height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(width > 600 ? 30 : 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // google logo
            Image.network(
              'https://lh3.googleusercontent.com/COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 25),
            // SIGN IN text
            Text(
              'Sign in',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // use your google account text
            Text(
              'Use your Google Account',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email or phone',
                labelStyle: GoogleFonts.roboto(
                    color: const Color.fromRGBO(255, 255, 255, 0.88),
                    fontWeight: FontWeight.w500),
                error: isEmailEmpty
                    ? Text("Email or phone cannot be empty",
                        style: GoogleFonts.roboto(color: Colors.red))
                    : null,
              ),
              style: GoogleFonts.roboto(color: Colors.white),
              controller: emailController,
              onChanged: (value) {
                if (isEmailEmpty != value.isEmpty) {
                  setState(() {
                    isEmailEmpty = value.isEmpty;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your password',
                labelStyle: GoogleFonts.roboto(
                    color: const Color.fromRGBO(255, 255, 255, 0.88),
                    fontWeight: FontWeight.w500),
                error: isPasswordEmpty
                    ? Text("Password cannot be empty",
                        style: GoogleFonts.roboto(color: Colors.red))
                    : null,
              ),
              style: GoogleFonts.roboto(color: Colors.white),
              controller: passwordController,
              onChanged: (value) {
                if (isPasswordEmpty != value.isEmpty) {
                  setState(() {
                    isPasswordEmpty = value.isEmpty;
                  });
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    launchUrl(_recoveryUrl, webOnlyWindowName: "_self");
                  },
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.roboto(
                      color: Color(0xFFAEC6F6),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // sign up button
                TextButton(
                  onPressed: () {
                    launchUrl(_signUpUrl, webOnlyWindowName: "_self");
                  },
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFAEC6F6),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // next button
                ElevatedButton(
                  onPressed: () {
                    // save email and password
                    String email = emailController.text;
                    String password = passwordController.text;
                    // check if email and password are empty
                    if (email.isEmpty || password.isEmpty) {
                      setState(() {
                        isEmailEmpty = email.isEmpty;
                        isPasswordEmpty = password.isEmpty;
                      });
                    } else {
                      // navigate to home page
                      Navigator.pushNamed(context, '/informUser');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      backgroundColor: Color(0xFFAEC6F6)),
                  child: Text(
                    'Next',
                    style: GoogleFonts.roboto(
                      color: Color(0xFF16316e),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
