import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/screens/auth/set_password_screen.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _pinVerifyInProgress = false;

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
                    Text('Pin Verification',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'A 6 digit verification pin will send to your email address',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPinCodeField(context),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _pinVerifyInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_globalKey.currentState!.validate()) {
                              _getPinVerify();
                            }
                          },
                          child: const Text('Verify')),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: _buildPinVerifySection(),
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

  Widget _buildPinCodeField(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          selectedColor: AppColors.themeColor,
          inactiveFillColor: Colors.white),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
    );
  }

  Widget _buildPinVerifySection() {
    return RichText(
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
    );
  }

  Future<void> _getPinVerify() async {
    _pinVerifyInProgress = true;
    if (mounted) {
      setState(() {});
    }
    String otp = _pinTEController.text.trim();
    final NetworkResponse response = await NetworkCaller.getRequest(
        Urls.recoverEmailOtp(widget.userEmail, otp));
    if (response.isSuccess && response.responseData['status'] == 'success') {
      debugPrint('otp ok');
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPasswordScreen(
                userEmail: widget.userEmail,
                otp: otp,
              ),
            ));
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Verification Failed! Try again');
      }
    }
    _pinVerifyInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onTapBackSignIn() {
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
    _pinTEController.dispose();
  }
}
