import 'package:flutter/material.dart';

import '../widgets/task_item.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
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
