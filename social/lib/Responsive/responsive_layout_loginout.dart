import 'package:flutter/material.dart';
import 'package:social/Desktop/login_page_d.dart';
import 'package:social/Desktop/register_page_d.dart'; // Assuming you have this
import 'package:social/Mobile/login_page_m.dart';
import 'package:social/Mobile/register_page_m.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/Tablet/login_page_t.dart';
import 'package:social/Tablet/register_page_t.dart';

class ResponsiveLayoutLoginout extends StatefulWidget {
  const ResponsiveLayoutLoginout({super.key});

  @override
  State<ResponsiveLayoutLoginout> createState() =>
      _ResponsiveLayoutLoginoutState();
}

class _ResponsiveLayoutLoginoutState extends State<ResponsiveLayoutLoginout> {
  bool isLoginPage = true;

  void _togglePage() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile layout
        if (constraints.maxWidth < mobileWidth) {
          return isLoginPage
              ? MyLoginPageMobile(
                  onTap: () {
                    setState(() {
                      _togglePage();
                    });
                  },
                )
              : MyRegisterPageMobile(onTap: () {
                  setState(() {
                    _togglePage();
                  });
                });
        }
        // Tablet layout
        else if (constraints.maxWidth < tabletWidth) {
          return isLoginPage
              ? MyLoginPageTablet(
                  onTap: () {
                    setState(() {
                      _togglePage();
                    });
                  },
                )
              : MyRegisterPageTablet(onTap: () {
                  setState(() {
                    _togglePage();
                  });
                });
        }
        // Desktop layout
        else {
          return isLoginPage
              ? MyLoginPageDesktop(
                  onTap: () {
                    setState(() {
                      _togglePage();
                    });
                  },
                )
              : MyRegisterPageDesktop(onTap: () {
                  setState(() {
                    _togglePage();
                  });
                });
        }
      },
    );
  }
}
