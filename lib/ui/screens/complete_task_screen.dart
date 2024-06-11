import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return const TaskItem();
              },
            ),
          )),
    );
  }
}
