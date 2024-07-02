import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

import '../utility/app_colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading:  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: MemoryImage(
                scale: 1,
                  base64Decode(AuthController.userData?.photo ?? ''),


              )
            )
          ),
         ),
    ),
    title: GestureDetector(

      onTap: (){
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen(),));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           AuthController.userData?.fullName ?? '',
            style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          Text(
            AuthController.userData?.email ?? '',
            style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    ),
    actions: [
      IconButton(
          onPressed: () async{
            await AuthController.clearAllData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          },
          icon: const Icon(Icons.logout))
    ],
  );
}