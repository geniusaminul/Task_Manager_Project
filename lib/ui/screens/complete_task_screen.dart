import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/task_model.dart';
import '../../data/utilities/urls.dart';
import '../widgets/task_item.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  List<TaskModel> completeTaskList = [];
  bool _completeTaskInProgress = false;

  @override
  void initState() {

    super.initState();
    _getCompleteTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Visibility(
                  visible: _completeTaskInProgress == false,
                  replacement: const CenterCircularProgressIndicator(),
                  child: ListView.builder(
                    itemCount: completeTaskList.length,
                    itemBuilder: (context, index) {
                    return TaskItem(
                      taskModel: completeTaskList[index],
                      onUpdateTask: () {
                        _getCompleteTasks();

                      },
                    );
                  },
                  ),
                ),
              ),),
        ],
      ),
    );
  }



  Future<void> _getCompleteTasks() async {
    _completeTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.completeTasks);
    if (response.isSuccess) {
      TaskListWrapperModel taskListWrapperModel =
      TaskListWrapperModel.fromJson(response.responseData);
      completeTaskList = taskListWrapperModel.taskList ?? [];

    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMessage ?? 'Get Completed Task failed! Try again');
      }

    }
    _completeTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

