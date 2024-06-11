import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

import '../utility/app_colors.dart';

AppBar profileAppBar(context, [bool fromUpdateProfile = false]) {
  return AppBar(
    backgroundColor: AppColors.themeColor,
    leading: const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(


      ),
    ),
    title: GestureDetector(

      onTap: (){
        if(fromUpdateProfile){
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen(),));
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dummy name',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
          Text(
            'example@gmail.com',
            style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    ),
    actions: [
      IconButton(onPressed: () {

      }, icon: const Icon(Icons.logout))
    ],
  );
}