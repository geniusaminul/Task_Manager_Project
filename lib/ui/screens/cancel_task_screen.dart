import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';

import '../widgets/task_item.dart';

class CancellTaskScreen extends StatefulWidget {
  const CancellTaskScreen({super.key});

  @override
  State<CancellTaskScreen> createState() => _CancellTaskScreenState();
}

class _CancellTaskScreenState extends State<CancellTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
              //  return TaskItem(taskModel: newTaskList[index]);
              },
            ),
          )),
    );
  }
}
