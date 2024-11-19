import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/shared/password_input.dart';
import 'package:flutter_application/widgets/shared/styled_button.dart';
import 'package:flutter_application/widgets/shared/styled_form_field.dart';
import 'package:flutter_application/widgets/shared/styled_text.dart';
import 'package:flutter_application/services/auth_service.dart';
import 'package:flutter_application/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorFeedback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sing up text
            Center(
                child: StyledBodyText(AppLocalizations.of(context)!.loginAcc)),
            const SizedBox(
              height: 16.0,
            ),

            // email address
            StyledFormField(
              textEditingController: _emailController,
              label: Text(AppLocalizations.of(context)!.emailAddress),
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.emailAddressIsNeeded;
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // password
            PasswordInput(
                textEditingController: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.passwordIsNeeded;
                  }
                  return null;
                },
                label: Text(AppLocalizations.of(context)!.password),
                icon: Icons.lock),
            const SizedBox(height: 16.0),

            // error feedback
            if (_errorFeedback != null)
              Center(
                  child: Text(_errorFeedback!,
                      style: const TextStyle(color: Colors.red))),

            // sumbit button
            FractionallySizedBox(
              widthFactor: 0.5,
              child: StyledButton(
                onPressed: () async {
                  setState(() {
                    _errorFeedback = null;
                  });

                  // Daje ! na końcu bo wiem że formKey nie będzie posiadać wartowści null
                  if (_formKey.currentState!.validate()) {
                    // trim żeby pozbyć się pustej przestrzeni
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    final user = await AuthService.signIn(email, password);

                    // error feedback
                    if (user == null) {
                      setState(() {
                        _errorFeedback =
                            AppLocalizations.of(context)!.invalideLogin;
                      });
                    }
                  }
                },
                child: StyledButtonText(AppLocalizations.of(context)!.login),
              ),
            )
          ],
        ),
      ),
    );
  }
}
