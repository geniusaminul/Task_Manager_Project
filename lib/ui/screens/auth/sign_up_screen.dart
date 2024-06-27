import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/utility/app_constant.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../../data/utilities/urls.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _registerInProgress = false;

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
                    Text('Join With Us',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      autovalidateMode:AutovalidateMode.onUserInteraction ,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return 'Enter Email Address';
                        }
                        if(AppConstant.regExp.hasMatch(value!)==false){
                          return 'Enter valid Email address';
                        }
                        return null;

                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _firstNameTEController,
                      autovalidateMode:AutovalidateMode.onUserInteraction ,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return "Write First Name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'First name',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _lastNameTEController,
                      autovalidateMode:AutovalidateMode.onUserInteraction ,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return "Write Last Name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Last name',
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _mobileTEController,
                      autovalidateMode:AutovalidateMode.onUserInteraction ,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return "Write Mobile Number";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Mobile',
                      ),
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      obscureText: _showPassword==false,
                      controller: _passwordTEController,
                      autovalidateMode:AutovalidateMode.onUserInteraction ,
                      validator: (String? value) {
                        if(value?.trim().isEmpty ?? true){
                          return "Write Password";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        hintText: 'Password', suffixIcon: IconButton(onPressed: () {
                          _showPassword = !_showPassword;
                          if(mounted){
                            setState(() {

                            });
                          }

                        }, icon: Icon( _showPassword ? Icons.remove_red_eye : Icons.visibility_off))
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _registerInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_globalKey.currentState!.validate()){
                              _registerUser();
                            }
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: _buildBackToSignInSection(),
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

  Widget _buildBackToSignInSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: AppColors.headingColor,
            fontWeight: FontWeight.w600,
            letterSpacing: .4),
        text: "Have an account?",
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _onTapBackSignIn();
              },
            text: '  Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
          )
        ],
      ),
    );
  }

  void _registerUser() async{
    _registerInProgress = true;
    if(mounted){
      setState(() {});
    }
    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": ""
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.registration, body: requestInput);
    _registerInProgress = false;
    if(mounted){
      setState(() {});
    }
    if (response.isSuccess) {
      _clearTextField();
      if (mounted) {
        showSnackBarMessage(context, 'Registration is Success');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Registration failed! try again');
      }
    }
  }

  void _onTapBackSignIn(){
    Navigator.pop(context);
  }
  void _clearTextField(){
    _emailTEController.clear();
    _passwordTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();

  }
  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _lastNameTEController.dispose();
    _firstNameTEController.dispose();
    _mobileTEController.dispose();
  }
}
