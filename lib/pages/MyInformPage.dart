import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInformPage extends StatelessWidget {
  const MyInformPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hey!",
                    style: GoogleFonts.roboto(
                        fontSize: 48, fontWeight: FontWeight.bold)),
                Text(
                  'It seems you used your Google Account to sign in. But the website you gave your sensitive information was not Google\'s offcial website😬 Don\'t worry, your information was not sent to any server nor stored. (You can check my github for source code)',
                  style: GoogleFonts.roboto(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                    ' Don\'t you believe me? Check the source code of this website or screenshot below! 😇',
                    style: GoogleFonts.roboto(fontSize: 28)),
                Image.asset('lib/images/urlScreenshot.png', width: 900),
                Text(
                    "As you can see, the URL of the website is not \"www.google.com\" nor any official Google website. It's just a simple website that I created to show you how phishing works. Attackers use this technique to steal your sensitive information. Be careful!",
                    style: GoogleFonts.roboto(fontSize: 20)),
                Text(
                    "For safety, there are some steps you should do before you input your sensitive information to a website: \n\t1. Check the URL of the website. \n\t2. Look for \"HTTPS\" in the URL: Ensure the website uses \"HTTPS\" instead of just \"HTTP.\" The \"S\" stands for \"Secure,\" indicating that the website encrypts your data. If the URL starts with \"HTTP,\" avoid entering sensitive information. \n\t3. Examine the Domain Name Carefully: Phishers often create websites with URLs that closely resemble legitimate sites but contain small errors (e.g., “g00gle.com” instead of “google.com”). Always verify the domain name carefully.\n\t5. Check for Spelling and Grammar Errors: Many phishing sites have poor spelling or grammar. Look for signs of unprofessional content, such as awkwardly worded sentences or strange font choices, which can be red flags.\n\t6. Avoid Clicking on Suspicious Links: Hover over links before clicking to see where they lead. Phishers often use disguised links that take you to fraudulent sites. If you don't recognize the link or it looks suspicious, don't click on it.\n\t7.Use Multi-Factor Authentication (MFA): Whenever possible, enable multi-factor authentication to add an extra layer of protection to your accounts. This can prevent attackers from accessing your sensitive information, even if they manage to steal your login credentials.\n\t8. Be Wary of Unsolicited Emails or Messages: If you receive an unexpected email or message asking for personal information or urging you to click on a link, be suspicious. Phishers often use urgency to trick people into acting quickly without thinking.\n\t9. Be Careful with Subdomains: Phishers often use subdomains to deceive users into thinking they are on a legitimate site. For example, google.surveylogin.com may appear to be a legitimate Google page because of the “google” part, but the actual domain is surveylogin.com, a phishing site. Always check the full URL, especially the part before the first slash (\"/\"). The main domain should match exactly with the official website, and any subdomains should look suspicious if they're unrelated to the company.",
                    style: GoogleFonts.roboto(fontSize: 20)),
                Text("Be careful next time!",
                    style: GoogleFonts.roboto(
                        fontSize: 48, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
