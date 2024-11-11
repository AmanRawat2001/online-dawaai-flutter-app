import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatelessWidget {
  // Function to launch URLs
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    print('Launching URL: $url');
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return AnimatedPadding(
      // Add padding for keyboard
      padding: EdgeInsets.only(
          bottom:
              keyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0),
      duration: Duration(milliseconds: 300),
      child: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 14),
              children: [
                TextSpan(text: 'By continuing, you agree to our \n'),
                TextSpan(
                  text: 'Terms of Service',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(
                          'https://onlinedawaai.com/#/terms-and-conditions');
                    },
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL('https://onlinedawaai.com/#/privacy-policy');
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
