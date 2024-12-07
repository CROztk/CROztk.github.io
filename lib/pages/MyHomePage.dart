// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: 640,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 640,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            border: Border.all(color: Colors.grey)),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Civan Rıdar Öztekin Cyber-Security Survey',
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "Please fill out the form below to help my cybersecurity project.",
                                style: GoogleFonts.roboto(),
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _signinTextWidget(width),
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '* Required',
                                style: GoogleFonts.roboto(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 640,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("Name - Surname ",
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text("*",
                              style: GoogleFonts.roboto(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: 40,
                          width: constraints.maxWidth / 2 - 20,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Your answer',
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 640,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("Your department ",
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text("*",
                              style: GoogleFonts.roboto(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: 40,
                          width: constraints.maxWidth / 2 - 20,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Your answer',
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 640,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text("E-mail address ",
                              style: GoogleFonts.roboto(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          Text("*",
                              style: GoogleFonts.roboto(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: 40,
                          width: constraints.maxWidth / 2 - 20,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Your answer',
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Next",
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              width: 300,
              height: 200,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Please sign in to continue',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'This form is anonymous. Your answers will not be linked to your Google account.',
                    style: GoogleFonts.roboto(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          overlayColor: Colors.green,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text("SIGN IN",
                            style: GoogleFonts.roboto(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _signinTextWidget(double width) {
    return width > 570
        ? Row(
            children: [
              Text(
                'To save your progress and continue later, please ',
                style: GoogleFonts.roboto(),
              ),
              Text("sign in to your Google account.",
                  style: GoogleFonts.roboto(color: Colors.blue)),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To save your progress and continue later, please ',
                style: GoogleFonts.roboto(),
              ),
              Text("sign in to your Google account.",
                  style: GoogleFonts.roboto(color: Colors.blue)),
            ],
          );
  }
}
