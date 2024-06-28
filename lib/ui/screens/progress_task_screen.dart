import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_wrapper_model.dart';
import 'package:task_manager/data/network_caller/network_caller.dart';
import 'package:task_manager/ui/widgets/center_circular_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/task_model.dart';
import '../../data/utilities/urls.dart';
import '../widgets/task_item.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _progressTaskInProgress = false;
  List<TaskModel> progressList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProgressTask();
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
                  visible: _progressTaskInProgress == false,
                  replacement: const CenterCircularProgressIndicator(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: progressList.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                    taskModel: progressList[index],
                    onUpdateTask: () {
                      _getProgressTask();
                    },
                  );
                },
                  ),
                ),
              )),
        ],
      ),
    );
  }
  Future<void> _getProgressTask() async{
    _progressTaskInProgress = true;
    if(mounted){
      setState(() {
        
      });
    }
    NetworkResponse response = await NetworkCaller.getRequest(Urls.progressTasks);
    if(response.isSuccess){
      TaskListWrapperModel taskListWrapperModel = TaskListWrapperModel.fromJson(response.responseData);
      progressList = taskListWrapperModel.taskList ?? [];
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Get Progress Task failed! Try again');
      }

    }
    _progressTaskInProgress = false;
    if(mounted){
      setState(() {

      });
    }
  }
}
