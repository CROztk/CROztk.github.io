// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
          child: Container(
        width: width > 600 ? 550 : width,
        height: width > 600 ? 500 : height,
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 10),
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
                  onPressed: () {},
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
