import 'package:flutter/material.dart';
import 'package:social/Desktop/main_page_d.dart';
import 'package:social/Mobile/main_page_m.dart';
import 'package:social/Responsive/dimensions.dart';
import 'package:social/Tablet/main_page_t.dart';

class ResponsiveLayoutMainmenu extends StatelessWidget {
  const ResponsiveLayoutMainmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return const MyMainPageMobile();
        } else if (constraints.maxWidth < tabletWidth) {
          return const MyMainPageTablet();
        } else {
          return const MyMainPageDesktop();
        }
      },
    );
  }
}
