import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/background_widget.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/profile_app_bar.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/user_model.dart';
import '../../data/utilities/urls.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _fNameTEController = TextEditingController();
  final TextEditingController _lNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    final userData = AuthController.userData!;
    _emailTEController.text = userData.email ?? '';
    _fNameTEController.text = userData.firstName ?? '';
    _lNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: profileAppBar(context, true),
        body: BackgroundWidget(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Update Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildPhotoPicker(),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _fNameTEController,
                      decoration: const InputDecoration(hintText: 'First Name'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _lNameTEController,
                      decoration: const InputDecoration(hintText: 'Last Name'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _passTEController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                      visible: _updateProfileInProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                          onPressed: () {
                            if(_globalKey.currentState!.validate()){
                              _updateProfile();
                            }

                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: double.maxFinite,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 100,
              height: 48,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.black38),
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Text(_selectedImage?.name ?? 'No image select', maxLines: 1,))
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    String encodePhoto= AuthController.userData?.photo ?? '';
    if (mounted) {
      setState(() {

      });
    }

    Map<String, dynamic> requestInputData = {
      "email": _emailTEController.text.trim(),
      "firstName": _fNameTEController.text.trim(),
      "lastName": _lNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),


    };
    if(_passTEController.text.isNotEmpty){
      requestInputData['password'] = _passTEController.text;
    }
    if(_selectedImage != null){
      File file = File(_selectedImage!.path);
      encodePhoto = base64Encode(file.readAsBytesSync());
      requestInputData['photo']= encodePhoto;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(
        Urls.profileUpdate, body: requestInputData);
    if (response.isSuccess && response.responseData['status'] == 'success') {
      UserModel userModel = UserModel(
        email: _emailTEController.text,
        firstName: _fNameTEController.text.trim(),
        lastName: _lNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        photo: encodePhoto,
      );
      await AuthController.saveUserData(userModel);
      _updateProfileInProgress = false;
      if (mounted) {
        setState(() {

        });
      }

      if (response.isSuccess) {
        if (mounted) {
          showSnackBarMessage(context, 'Profile Update Success!');
        }
      } else {
        if (mounted) {
          showSnackBarMessage(context,
              response.errorMessage ?? 'Profile Update failed! try again');
        }
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final imagePicker = ImagePicker();
    final XFile?
    result = await imagePicker.pickImage(source: ImageSource.camera);
    if(result != null){
      _selectedImage = result;
      if(mounted){
        setState(() {

        });
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
    _fNameTEController.dispose();
    _lNameTEController.dispose();
    _mobileTEController.dispose();
    _passTEController.dispose();
  }

}
