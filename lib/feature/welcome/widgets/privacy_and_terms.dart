
import 'package:flutter/material.dart';
import 'package:whatsapp_me/common/extension/custom_theme_extension.dart';

class PrivacyAndTerms extends StatelessWidget {
  const PrivacyAndTerms({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Read Our ',
              style:
                  TextStyle(color: context.theme.greyColor, height: 1.5),
              children: [
                TextSpan(
                    text: 'Privacy Policy ',
                    style: TextStyle(color: context.theme.blueColor)),
                const TextSpan(
                    text:
                        'Tap "Agree and Continue" to accept the '),
                TextSpan(
                    text: 'Terms of Sevices.',
                    style: TextStyle(color: context.theme.blueColor)),
              ])),
    );
  }
}
