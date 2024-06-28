import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancel_task_screen.dart';
import 'package:task_manager/ui/screens/complete_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import 'package:task_manager/ui/utility/app_colors.dart';

import '../widgets/profile_app_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
   int _selectedIndex = 0;
  final List<Widget> _screens = const[
    NewTaskScreen(),
    CompleteTaskScreen(),
    ProgressTaskScreen(),
    CancelTaskScreen()

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar(context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
       selectedItemColor: AppColors.themeColor,
        showSelectedLabels: true,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,

        onTap: (index){
          _selectedIndex= index;
          if(mounted){
            setState(() {});
          }
        },
        items: const [

          BottomNavigationBarItem(icon: Icon(Icons.task), label:'New Task'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label:'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label:'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label:'Cancel'),
        ],
      ),
    );
  }


}
