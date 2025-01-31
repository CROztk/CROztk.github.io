import 'package:flutter/material.dart';
import 'package:social/Desktop/login_page_d.dart';
import 'package:social/Mobile/login_page_m.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/Tablet/login_page_t.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return const MyLoginPageMobile();
        } else if (constraints.maxWidth < tabletWidth) {
          return const MyLoginPageTablet();
        } else {
          return const MyLoginPageDesktop();
        }
      },
    );
  }
}
