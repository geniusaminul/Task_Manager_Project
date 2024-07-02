import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../../data/utilities/urls.dart';
import '../../utility/app_constant.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _emailVerifyInProgress = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text('Your Email Address',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                        'A 6 digit verification pin will send to your email address',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Email Address';
                        }
                        if (AppConstant.regExp.hasMatch(value!) == false) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _emailVerifyInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_globalKey.currentState!.validate()){
                              _getEmailVerify();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: _buildSingInSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingInSection() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
                color: AppColors.headingColor,
                fontWeight: FontWeight.w600,
                letterSpacing: .4),
            text: "Have account?",
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = _onTapBackSignIn,
                text: '  Sign in',
                style: const TextStyle(
                  color: AppColors.themeColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _getEmailVerify() async{
    _emailVerifyInProgress = true;
    if (mounted) {
      setState(() {});
    }

    String userEmail = _emailTEController.text.trim();
     NetworkResponse response = await NetworkCaller.getRequest(Urls.recoverVerifyEmail(userEmail));

    if(response.isSuccess){
     if(mounted){
       Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) =>  PinVerificationScreen(userEmail: userEmail,),
           ));
     }
    } else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Email Verify failed! Try again');
      }
    }
    _emailVerifyInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }



  void _onTapBackSignIn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
  }
}
