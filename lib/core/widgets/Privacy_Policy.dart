import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: Colors.grey[100],
          fontSize: 12,
          height: 1.5,
        ),
        children: <TextSpan>[
          TextSpan(
            text:
            '${AppLocalizations.of(context)!.byContinuingYouAgreeToOur} ',
          ),
          TextSpan(
            text: AppLocalizations.of(context)!.termsOfService,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to Terms of Service
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.termsOfServiceClicked,
                    ),
                  ),
                );
              },
          ),
          TextSpan(text: AppLocalizations.of(context)!.and),
          TextSpan(
            text: AppLocalizations.of(context)!.privacyPolicy,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: Navigate to Privacy Policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(
                        context,
                      )!.privacyPolicyClicked,

                    ),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}