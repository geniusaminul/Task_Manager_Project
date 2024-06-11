import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text('Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('A 6 digit verification pin will send to your email address',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),


                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: _onTapEmailVerifyButton,
                      child: const Icon(Icons.arrow_circle_right_outlined)),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Column(
                      children: [

                        RichText(
                          text:  TextSpan(
                            style: const TextStyle(
                                color: AppColors.headingColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .4),
                            text: "Have account?",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapBackSignIn,
                                text: '  Sign in',
                                style: const TextStyle(
                                  color: AppColors.themeColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapEmailVerifyButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PinVerificationScreen(),
        ));
  }

  void _onTapBackSignIn(){
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();

  }
}
