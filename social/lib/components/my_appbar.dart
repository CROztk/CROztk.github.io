import 'package:flutter/material.dart';
import 'package:social/Theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key, required this.title, this.leading});

  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentLanguage = themeNotifier.currentLanguage;
    return AppBar(
      title: Text(title),
      elevation: 1,
      actions: [
        Row(
          children: [
            IconButton(
              icon: Row(
                children: [
                  Text("${currentLanguage["language"] ?? "en"}|"),
                  const Icon(Icons.language),
                ],
              ),
              padding: const EdgeInsets.all(8),
              onPressed: () {
                themeNotifier.setLanguage(
                    currentLanguage["language"] == "en" ? "tr" : "en");
              },
            ),
            IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () {
                themeNotifier.toggleThemeMode();
              },
            ),
          ],
        ),
      ],
      leading: leading,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56.0);
}
