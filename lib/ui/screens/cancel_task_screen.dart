import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/data/utilities/urls.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../widgets/task_item.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {
  bool _cancelInProgress = false;
  List<TaskModel> cancelTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCancelTask();
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
                  visible: _cancelInProgress == false,
                  replacement: const CenterCircularProgressIndicator(),
                  child: ListView.builder(
                    itemCount: cancelTaskList.length,
                    itemBuilder: (context, index) {
                     return TaskItem(taskModel: cancelTaskList[index], onUpdateTask: () {
                       _getCancelTask();
                     },);
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
  Future<void> _getCancelTask() async{
    _cancelInProgress = true;
    if(mounted){
      setState(() {

      });
    }
   NetworkResponse response = await NetworkCaller.getRequest(Urls.cancelTasks);
    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      cancelTaskList = taskListWrapperModel.taskList ?? [];
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Get Cancel task failed! try again');
      }
    }
    _cancelInProgress = false;
    if(mounted){
      setState(() {

      });
    }
  }
}
