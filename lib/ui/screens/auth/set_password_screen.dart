import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/snack_bar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.userEmail, required this.otp});
   final String userEmail;
   final String otp;
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPassTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _setPasswordInProgress = false;

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
                    Text('Set Password',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Minimum length password 8 character with Latter and number combination',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter Password';
                        }
                        return null;

                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _confirmPassTEController,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Confirm Password';
                        }
                        if ( value! != _passwordTEController.text) {
                          return "Password didn't match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _setPasswordInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_globalKey.currentState!.validate()){
                              _resetUserPassword();
                            }
                          },
                          child: const Text('Confirm')),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: _buildSetPasswordSection(),
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

  Widget _buildSetPasswordSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: AppColors.headingColor,
            fontWeight: FontWeight.w600,
            letterSpacing: .4),
        text: "Have account",
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
            text: '  Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
          )
        ],
      ),
    );
  }
  void _resetUserPassword() async{
    _setPasswordInProgress = true;
    if(mounted){
      setState(() {});
    }
    Map<String, dynamic> requestInput = {
      "email": widget.userEmail,
      "OTP":widget.otp,
      "password": _confirmPassTEController.text

    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.resetPassword, body: requestInput);

    if (response.isSuccess) {
      if(mounted){
        showSnackBarMessage(context, 'Password reset successful');

      }


    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Registration failed! try again');
      }
    }
    _setPasswordInProgress = false;
    if(mounted){
      setState(() {});
    }
  }
 void _onTapSignIn(){
   Navigator.pushAndRemoveUntil(
     context,
     MaterialPageRoute(
       builder: (context) => const SignInScreen(),
     ),
         (route) => false,
   );
 }

  @override
  void dispose() {
    super.dispose();
    _confirmPassTEController.dispose();
    _passwordTEController.dispose();
  }
}
